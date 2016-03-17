package vectorx.font;

//import logger.Logger;
import types.Color4F;
import haxe.ds.StringMap;
import types.Range;
import vectorx.font.AttributedString.StringAttributes;
import haxe.Utf8;
import StringTools;

using StringTools;

class StyledStringAttribute
{
    public var stringAttributes: StringAttributes;
    public var priority: Int;

    public function new(attr: StringAttributes, priority: Int)
    {
        this.stringAttributes = attr;
        this.priority = priority;
    }
}

class StyledStringParser
{
    private var attributesStack: Array<StringAttributes>;
    private var currentAttribute: StringAttributes;
    private var currentString: StringBuf;
    private var sourceString: String;
    private var currentCharIndex: Int;
    private var currentChar: String;
    private var resultAttributes: Array<StyledStringAttribute>;
    private var isEscapeChar: Bool = false;

    public function new()
    {

    }

    private function reset(): Void
    {
        attributesStack = new Array<StringAttributes>();
        resultAttributes = new Array<StyledStringAttribute>();
        currentString = new StringBuf();
        currentCharIndex = 0;
        sourceString = null;
        currentAttribute = null;

        var range: AttributedRange = new AttributedRange(currentString.length, 0);
        var rootAttr: StringAttributes = {range: range};
        pushAttribute(rootAttr);
    }

    private function nextChar(): String
    {
        isEscapeChar = false;
        if (currentCharIndex >= sourceString.length)
        {
            throw "unexpected end of string";
        }

        currentChar = Utf8.sub(sourceString, ++currentCharIndex, 1);
        if (currentChar == "\\")
        {
            var char = nextChar();
            isEscapeChar = true;
            switch (char)
            {
                case "n": currentChar = "\n";
                case "t": currentChar = "\t";
            }
        }

        return currentChar;
    }

    private function readCode(): String
    {
        var code: StringBuf = new StringBuf();
        while (nextChar() != "]")
        {
            code.add(currentChar);
        }

        return code.toString();
    }

    private function readAttachment(): String
    {
        var attachment: StringBuf = new StringBuf();
        while (nextChar() != "}")
        {
            attachment.add(currentChar);
        }

        return attachment.toString();
    }

    private function parseAttachment(): Void
    {
        var attachmentName = readAttachment();
        var range: AttributedRange = new AttributedRange(currentString.length, 0);

        var kern: Null<Float> = null;
        var font: Font = null;

        var attr: StringAttributes =
        {
            range: range,
            font: currentAttribute.font,
            foregroundColor: currentAttribute.foregroundColor,
            backgroundColor: currentAttribute.backgroundColor,
            baselineOffset: currentAttribute.baselineOffset,
            kern: currentAttribute.kern,
            strokeWidth: currentAttribute.strokeWidth,
            strokeColor: currentAttribute.strokeColor
        };

        currentAttribute.attachmentId = attachmentName;

        popAttribute();
        pushAttribute(attr);
    }

    private function parseCode(aliases: FontAliasesStorage, cache: FontCache, colors: StringMap<Color4F>): Void
    {
        var code = readCode();
        var codes = code.split(",");
        var range: AttributedRange = new AttributedRange(currentString.length, 0);
        var attr: StringAttributes = {range: range};
        var sizeOverride: Null<Float> = null;

        for (code in codes)
        {
            var kv: Array<String> = code.trim().split('=');

            if (kv[0].startsWith("/"))
            {
                popAttribute();
                return;
            }

            //trace('k: ${kv[0]} v: ${kv[1]}');

            if (kv[0].length == 0)
            {
                continue;
            }

            switch(kv[0])
            {
                case "f" | "font":
                    {
                        var font = aliases.getFont(kv[1], cache);
                        if (font == null)
                        {
                            throw 'Font alias ${kv[1]} is not found';
                        }

                        attr.font = font;
                    }

                case "c" | "color":
                    {
                        var color = colors.get(kv[1]);
                        if (color == null)
                        {
                            throw 'Color ${kv[1]} is not found';
                        }
                        attr.foregroundColor = color;
                    }
                case "s" | "size":
                    {
                        try
                        {
                            var size = Std.parseFloat(kv[1]);
                            if (size != 0)
                            {
                                sizeOverride = size;
                            }
                        }
                        catch(ex: Dynamic)
                        {

                        }
                    }
                case "bg" | "background":
                    {
                        var color = colors.get(kv[1]);
                        if (color == null)
                        {
                            throw 'Background color ${kv[1]} is not found';
                        }
                        attr.backgroundColor = color;
                    }
                case "basline": attr.baselineOffset = Std.parseFloat(kv[1]);
                case "kern": attr.kern = Std.parseFloat(kv[1]);
                case "strokeWidth" | "sw": attr.strokeWidth = Std.parseFloat(kv[1]);
                case "strokeColor" | "sc": attr.strokeColor = colors.get(kv[1]);
                default: throw('undefined code "${kv[0]}"');
            }
        }

        if (sizeOverride != null)
        {
            if (attr.font == null)
            {
                attr.font = cache.createFontWithNameAndSize("", sizeOverride);
            }
            else
            {
                attr.font = attr.font.clone(sizeOverride);
            }

        }
        pushAttribute(attr);
    }

    private function pushAttribute(attribute: StringAttributes): StringAttributes
    {
        //trace('pushAttribute $attribute');

        attributesStack.push(attribute);
        currentAttribute = attribute;
        return currentAttribute;
    }

    private function popAttribute(): StringAttributes
    {
        var priority = attributesStack.length;
        var attr = attributesStack.pop();
        //trace('popAttribute $attr');

        resultAttributes.push(new StyledStringAttribute(attr, priority));
        if (attributesStack.length > 0)
        {
            currentAttribute = attributesStack[attributesStack.length - 1];
        }
        else
        {
            currentAttribute = null;
        }

        return currentAttribute;
    }

    private function updateAttributes()
    {
        for (attr in attributesStack)
        {
            attr.range.length++;
        }
    }

    public function toAttributedString(styledString: String, fontAliases: FontAliasesStorage, fontCache: FontCache, colors: StringMap<Color4F>): AttributedString
    {
        reset();

        sourceString = styledString;
        currentChar = Utf8.sub(styledString, currentCharIndex, 1);

        while (currentCharIndex < Utf8.length(styledString))
        {
            if (currentChar == '[' && !isEscapeChar)
            {
                parseCode(fontAliases, fontCache, colors);
            }
            else if (currentChar == '{' && !isEscapeChar)
            {
                parseAttachment();
            }
            else
            {
                currentString.add(currentChar);
                //trace(currentString);
                updateAttributes();
            }

            nextChar();
        }

        resultAttributes.sort(function(a: StyledStringAttribute, b: StyledStringAttribute) : Int
        {
            if (a.priority == b.priority)
            {
                return 0;
            }
            if (a.priority > b.priority)
            {
                return 1;
            }

            return -1;
        });

        //trace(resultAttributes);

        var attrString = new AttributedString(currentString.toString());
        var defaultAttr =
        {
            font: fontCache.createFontWithNameAndSize(null, 25),
            range: new AttributedRange(0, currentString.length)
        };
        attrString.applyAttributes(defaultAttr);

        for (attr in resultAttributes)
        {
            //trace(attr);
            attrString.applyAttributes(attr.stringAttributes);
        }

        reset();

        return attrString;

    }
}