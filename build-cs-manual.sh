#!/usr/bin/env bash

#compile

#debug
#haxe -main csharp.VectorxCs -cp vectorx -cp csharp -cs Export/csharp -lib duell_aggx -D dll -D erase-generics -D net-ver=20 -v -D real-position -D vectorDebugDraw -debug

haxe -main csharp.VectorxCs -cp vectorx -cp csharp -cs Export/csharp -lib duell_aggx -D dll -D erase-generics -D net-ver=20 -v -D real-position

cd Export/csharp

#postprocess sources

#remove invalid attribute
find . -name "*.cs" -print0 | xargs -0 sed -i '' \
 -e 's/\[global::System.ComponentModel.EditorBrowsable(global::System.ComponentModel.EditorBrowsableState.Never)]/ /g'

#remove invalid type conversion
#find . -name "StyledStringContext.cs" -print0 | xargs -0 sed -i '' \
# -e '/global::Array _/b' -e 's/(global::Array)/ /g'

#build assembly manually
#debug
#mcs /noconfig /debug:full /debug+ /optimize- /out:bin/VectorxCs.dll \
mcs /noconfig /debug:full /debug- /optimize+ /out:bin/VectorxCs.dll \
src/aggx/renderer/PixelFormatRenderer.cs \
src/aggx/core/utils/Debug.cs \
src/types/VerticalAlignment.cs \
src/aggx/vectorial/VertexDistance.cs \
src/aggx/vectorial/VertexSequence.cs \
src/cs/Boot.cs \
src/Std.cs \
src/aggx/rfpx/data/NameTable.cs \
src/aggx/vectorial/generators/IMarkerGenerator.cs \
src/Xml.cs \
src/vectorx/svg/SvgContext.cs \
src/aggx/svg/SVGPathTokenizer.cs \
src/aggx/core/geometry/AffineTransformer.cs \
src/aggx/core/geometry/Vector2D.cs \
src/aggx/core/geometry/Rect.cs \
src/aggx/core/StreamInterface.cs \
src/aggx/vectorial/QuadCurveFitterInc.cs \
src/aggx/vectorial/converters/ConvStroke.cs \
src/aggx/color/IGradientFunction.cs \
src/aggx/typography/Typeface.cs \
src/aggx/vectorial/CubicCurveFitterDiv.cs \
src/haxe/Log.cs \
src/aggx/core/memory/MemoryReader.cs \
src/aggx/renderer/DirectGammaApplier.cs \
src/aggx/svg/SVGPathParser.cs \
src/aggx/svg/SVGDataBuilder.cs \
src/aggx/rasterizer/LiangBarskyClipper.cs \
src/aggx/rasterizer/ScanlineRasterizer.cs \
src/aggx/rfpx/data/HheaTable.cs \
src/Array.cs \
src/aggx/core/memory/MemoryWriter.cs \
src/aggx/svg/SVGStringParsers.cs \
src/cs/internal/Function.cs \
src/aggx/vectorial/InnerJoin.cs \
src/vectorx/svg/SvgElementSerializer.cs \
src/aggx/vectorial/VectorPath.cs \
src/aggx/svg/XmlExtender.cs \
src/vectorx/font/StyledStringContext.cs \
src/types/RectF.cs \
src/aggx/rfpx/data/CmapFormat2.cs \
src/aggx/vectorial/QuadCurveFitterDiv.cs \
src/aggx/rasterizer/Scanline.cs \
src/aggx/vectorial/PathFlags.cs \
src/aggx/color/ISpanGenerator.cs \
src/vectorx/ColorStorage.cs \
src/aggx/svg/SVGColors.cs \
src/aggx/rfpx/data/LocaTable.cs \
src/aggx/svg/SVGPathBounds.cs \
src/aggx/color/GradientRadialFocus.cs \
src/vectorx/font/FontAliasesStorage.cs \
src/aggx/color/SpanInterpolatorLinear.cs \
src/aggx/vectorial/IVertexSource.cs \
src/aggx/vectorial/Ellipse.cs \
src/haxe/format/JsonParser.cs \
src/haxe/format/JsonPrinter.cs \
src/aggx/renderer/ClippingRenderer.cs \
src/aggx/core/math/Calc.cs \
src/aggx/svg/SVGData.cs \
src/aggx/svg/SVGElement.cs \
src/aggx/rfpx/data/CmapTable.cs \
src/aggx/rfpx/data/CmapFormat4.cs \
src/vectorx/font/AttributedSpan.cs \
src/aggx/rfpx/GlyphPoint.cs \
src/vectorx/font/FontAttachmentStorage.cs \
src/aggx/rfpx/data/GlyfTable.cs \
src/aggx/core/utils/Bits.cs \
src/haxe/io/Eof.cs \
src/aggx/rasterizer/FillingRule.cs \
src/aggx/rfpx/data/CmapFormat6.cs \
src/Type.cs \
src/Date.cs \
src/types/HorizontalAlignment.cs \
src/vectorx/font/FontAttachment.cs \
src/aggx/vectorial/VertexBlockStorage.cs \
src/aggx/core/memory/MemoryAccess.cs \
src/aggx/vectorial/generators/ICurveGenerator.cs \
src/vectorx/svg/SvgGradientSerializer.cs \
src/aggx/rfpx/data/TTCHeader.cs \
src/aggx/core/utils/ArrayUtil.cs \
src/aggx/vectorial/converters/ConvCurve.cs \
src/types/Color4F.cs \
src/aggx/renderer/ScanlineRenderer.cs \
src/vectorx/font/StyledStringParser.cs \
src/aggx/vectorial/converters/ConvDash.cs \
src/aggx/rasterizer/IRasterizer.cs \
src/aggx/core/geometry/ITransformer.cs \
src/aggx/rasterizer/IScanline.cs \
src/vectorx/font/FontContext.cs \
src/types/RectI.cs \
src/aggx/rfpx/Glyph.cs \
src/aggx/rfpx/data/HeadTable.cs \
src/aggx/rfpx/data/EncodingRecord.cs \
src/vectorx/font/TextLayout.cs \
src/aggx/vectorial/BezierArcSvg.cs \
src/vectorx/font/AttributedSpanStorage.cs \
src/StringTools.cs \
src/aggx/rasterizer/CoverScale.cs \
src/types/Range.cs \
src/aggx/rfpx/TrueTypeFont.cs \
src/aggx/rasterizer/PixelCellDataExtensions.cs \
src/aggx/rasterizer/PolySubpixelScale.cs \
src/aggx/color/IColorFunction.cs \
src/aggx/renderer/SolidScanlineRenderer.cs \
src/Reflect.cs \
src/vectorx/font/LayoutBehaviour.cs \
src/vectorx/font/StyleProviderInterface.cs \
src/vectorx/font/StyleStorage.cs \
src/vectorx/font/StringStyle.cs \
src/aggx/renderer/IRenderer.cs \
src/aggx/vectorial/LineJoin.cs \
src/aggx/vectorial/NullMarkers.cs \
src/aggx/rfpx/data/LongHorMetric.cs \
src/aggx/color/RgbaColor.cs \
src/aggx/rfpx/data/CmapFormat0.cs \
src/aggx/renderer/InverseGammaApplier.cs \
src/types/DataStringTools.cs \
src/aggx/rfpx/SegmentIterator.cs \
src/aggx/typography/TypefaceCache.cs \
src/aggx/rfpx/data/MaxpTable.cs \
src/aggx/calculus/Dda2LineInterpolator.cs \
src/aggx/core/geometry/Coord.cs \
src/aggx/RowInfo.cs \
src/aggx/core/geometry/RectBox.cs \
src/aggx/rfpx/data/Panose.cs \
src/aggx/typography/FontEngine.cs \
src/haxe/Constraints.cs \
src/aggx/color/GammaLookupTable.cs \
src/csharp/VectorxCs.cs \
src/aggx/color/SpanAllocator.cs \
src/aggx/rfpx/data/HmtxTable.cs \
src/haxe/ds/ObjectMap.cs \
src/aggx/RenderingBuffer.cs \
src/aggx/vectorial/generators/VcgenContour.cs \
src/aggx/core/memory/RgbaReaderWriter.cs \
src/vectorx/svg/SvgSerializer.cs \
src/haxe/ds/GenericStack.cs \
src/haxe/xml/Parser.cs \
src/types/Vector2.cs \
src/aggx/svg/gradients/GradientManager.cs \
src/aggx/rfpx/data/GlyphRecordComp.cs \
src/vectorx/svg/SvgVectorPathSerializer.cs \
src/aggx/color/RgbaColorF.cs \
src/aggx/rasterizer/ClippingScanlineRasterizer.cs \
src/haxe/ds/StringMap.cs \
src/aggx/color/ISpanAllocator.cs \
src/aggx/rasterizer/PixelCell.cs \
src/vectorx/font/FontShadow.cs \
src/aggx/vectorial/PathCommands.cs \
src/aggx/renderer/BlenderBase.cs \
src/aggx/vectorial/QuadCurve.cs \
src/aggx/rasterizer/PixelCellRasterizer.cs \
src/vectorx/font/TextLine.cs \
src/aggx/vectorial/converters/ConvContour.cs \
src/aggx/core/utils/DataPointer.cs \
src/aggx/vectorial/converters/ConvAdaptorVcgen.cs \
src/aggx/rfpx/data/NameRecord.cs \
src/aggx/vectorial/LineCap.cs \
src/vectorx/svg/SvgDataWrapper.cs \
src/aggx/rfpx/ContourSegment.cs \
src/aggx/rfpx/data/LangTagRecord.cs \
src/cs/internal/Iterator.cs \
src/aggx/rfpx/data/TableRecord.cs \
src/aggx/vectorial/PathUtils.cs \
src/cs/internal/StringExt.cs \
src/cs/internal/Runtime.cs \
src/cs/Lib.cs \
src/aggx/rasterizer/SpanIterator.cs \
src/aggx/rasterizer/ScanlineHitTest.cs \
src/aggx/core/geometry/RectBoxI.cs \
src/aggx/rfpx/TrueTypeCollection.cs \
src/aggx/core/memory/MemoryReaderEx.cs \
src/aggx/rfpx/data/GlyphDescrComp.cs \
src/aggx/rfpx/data/GlyphRecord.cs \
src/aggx/color/GradientX.cs \
src/aggx/rasterizer/GammaPower.cs \
src/aggx/vectorial/converters/ConvTransform.cs \
src/cs/internal/HxObject.cs \
src/aggx/color/ISpanInterpolator.cs \
src/types/DataType.cs \
src/aggx/rasterizer/IGammaFunction.cs \
src/cs/internal/Exceptions.cs \
src/vectorx/font/Font.cs \
src/Math.cs \
src/vectorx/font/AttributedRange.cs \
src/aggx/rfpx/GlyphContour.cs \
src/aggx/rasterizer/Span.cs \
src/haxe/lang/FieldLookup.cs \
src/aggx/rasterizer/ISpanIterator.cs \
src/vectorx/font/AttributedString.cs \
src/aggx/svg/SVGRenderer.cs \
src/aggx/rfpx/data/TableTags.cs \
src/aggx/core/memory/MemoryUtils.cs \
src/vectorx/font/RenderingStack.cs \
src/vectorx/font/FontCache.cs \
src/aggx/rfpx/data/OffsetTable.cs \
src/aggx/vectorial/CubicCurveFitterInc.cs \
src/aggx/rfpx/data/Os2Table.cs \
src/aggx/svg/SVGUseElement.cs \
src/vectorx/font/StyledString.cs \
src/aggx/rfpx/data/GlyphDescrSimple.cs \
src/aggx/vectorial/CubicCurve.cs \
src/aggx/svg/SVGParser.cs \
src/aggx/rfpx/data/PostTable.cs \
src/aggx/vectorial/IDistanceProvider.cs \
src/aggx/vectorial/MathStroke.cs \
src/types/Data.cs \
src/aggx/core/memory/Ref.cs \
src/aggx/vectorial/generators/VcgenDash.cs \
src/haxe/ds/IntMap.cs \
src/aggx/vectorial/generators/VcgenStroke.cs \
src/aggx/color/SpanGradient.cs \
src/aggx/svg/gradients/SVGGradient.cs \
src/aggx/color/ColorArray.cs \
src/haxe/CallStack.cs \
src/StringBuf.cs \
src/vectorx/font/StackBlur.cs \
src/vectorx/misc/UnionFind.cs \
src/vectorx/ColorStorageAccessor.cs \
src/vectorx/font/AttributedStringPart.cs \
src/types/Color4B.cs \
/target:library \
/define:"DEBUG;TRACE" \
/platform:x86 \
/warn:4 \
/sdk:2.0

#copy result to unitilayout and unity_editor
rm -f bin/VectorxCs-Debug*.*
cp bin/VectorxCs*.* ~/.duell/lib/duellbuildunitylayout/unityshared/
cp bin/VectorxCs*.* ~/.duell/lib/unity_editor/demo/Assets/UnityLayout/

cd ../..