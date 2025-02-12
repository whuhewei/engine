// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer' as developer;
import 'dart:typed_data';
import 'dart:ui';

import 'package:litetest/litetest.dart';
import 'package:vm_service/vm_service.dart' as vms;
import 'package:vm_service/vm_service_io.dart';

void main() {
  test('simple iplr shader can be re-initialized', () async {
    vms.VmService? vmService;
    try {
      final FragmentProgram program = await FragmentProgram.fromAssetAsync(
        'functions.frag.iplr',
      );
      final Shader shader = program.shader(
        floatUniforms: Float32List.fromList(<double>[1]),
      );

      final developer.ServiceProtocolInfo info = await developer.Service.getInfo();

      if (info.serverUri == null) {
        fail('This test must not be run with --disable-observatory.');
      }

      vmService = await vmServiceConnectUri(
        'ws://localhost:${info.serverUri!.port}${info.serverUri!.path}ws',
      );
      final vms.VM vm = await vmService.getVM();

      expect(vm.isolates!.isNotEmpty, true);
      for (final vms.IsolateRef isolateRef in vm.isolates!) {
        final vms.Response response = await vmService.callServiceExtension(
          'ext.ui.window.reinitializeShader',
          isolateId: isolateRef.id,
          args: <String, Object>{
            'assetKey': 'functions.frag.iplr',
          },
        );
        expect(response.type == 'Success', true);
      }
    } finally {
      await vmService?.dispose();
    }
  });
}
