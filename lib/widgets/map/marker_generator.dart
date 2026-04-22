import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerGenerator {
  /// Converts a [Widget] into a [BitmapDescriptor] for Google Maps markers.
  static Future<BitmapDescriptor> createCustomMarkerBitmap(Widget widget, {Size size = const Size(120, 50)}) async {
    final RenderRepaintBoundary boundary = RenderRepaintBoundary();
    final buildOwner = BuildOwner(focusManager: FocusManager());
    final pipelineOwner = PipelineOwner();

    final rootView = RenderView(
      view: ui.PlatformDispatcher.instance.implicitView!,
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.tight(size),
        devicePixelRatio: 3.0,
      ),
      child: RenderPositionedBox(child: boundary),
    );

    pipelineOwner.rootNode = rootView;
    rootView.prepareInitialFrame();

    final element = RenderObjectToWidgetAdapter<RenderBox>(
      container: boundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          color: Colors.transparent,
          child: widget,
        ),
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(element);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }
}
