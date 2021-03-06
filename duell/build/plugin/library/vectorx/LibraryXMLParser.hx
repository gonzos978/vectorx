package duell.build.plugin.library.vectorx;

import duell.build.objects.DuellProjectXML;
import duell.build.objects.Configuration;

import duell.build.plugin.library.vectorx.LibraryConfiguration;

import duell.helpers.XMLHelper;

import haxe.xml.Fast;

class LibraryXMLParser
{
    public static function parse(xml: Fast): Void
    {
        Configuration.getData().LIBRARY.VECTORX = LibraryConfiguration.getData();

        for (element in xml.elements)
        {
            if (!XMLHelper.isValidElement(element, DuellProjectXML.getConfig().parsingConditions))
            {
                continue;
            }

            switch(element.name)
            {
                case 'forceUpscale':
                    parseForceUpscaleElement(element);
            }
        }
    }

    private static function parseForceUpscaleElement(element: Fast): Void
    {
        LibraryConfiguration.getData().FORCE_UPSCALE = true;

        trace(LibraryConfiguration.getData());
    }
}
