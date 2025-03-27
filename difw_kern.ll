; ModuleID = 'src/ebpf/difw_kern.c'
source_filename = "src/ebpf/difw_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { [14 x i32]*, [4 x i32]*, [4 x i32]*, [2 x i32]* }
%struct.xdp_md = type { i32, i32, i32, i32, i32, i32 }

@xdp_tx_ports = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !15
@llvm.compiler.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @diwf to i8*), i8* bitcast (%struct.anon* @xdp_tx_ports to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @diwf(%struct.xdp_md* nocapture noundef readonly %0) #0 section "difw" !dbg !55 {
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !68, metadata !DIExpression()), !dbg !71
  %2 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 3, !dbg !72
  %3 = load i32, i32* %2, align 4, !dbg !72, !tbaa !73
  call void @llvm.dbg.value(metadata i32 %3, metadata !69, metadata !DIExpression()), !dbg !71
  switch i32 %3, label %10 [
    i32 1, label %5
    i32 2, label %4
  ], !dbg !78

4:                                                ; preds = %1
  call void @llvm.dbg.value(metadata i32 1, metadata !70, metadata !DIExpression()), !dbg !71
  br label %5

5:                                                ; preds = %1, %4
  %6 = phi i32 [ 1, %4 ], [ 2, %1 ], !dbg !79
  call void @llvm.dbg.value(metadata i32 %6, metadata !70, metadata !DIExpression()), !dbg !71
  %7 = tail call i64 inttoptr (i64 51 to i64 (i8*, i32, i64)*)(i8* noundef bitcast (%struct.anon* @xdp_tx_ports to i8*), i32 noundef %6, i64 noundef 0) #2, !dbg !81
  %8 = icmp slt i64 %7, 0, !dbg !83
  %9 = select i1 %8, i32 1, i32 4, !dbg !71
  br label %10, !dbg !71

10:                                               ; preds = %5, %1
  %11 = phi i32 [ 2, %1 ], [ %9, %5 ], !dbg !71
  ret i32 %11, !dbg !84
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!50, !51, !52, !53}
!llvm.ident = !{!54}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_tx_ports", scope: !2, file: !3, line: 39, type: !33, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !14, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "src/ebpf/difw_kern.c", directory: "/home/vagrant/repository/code/go/src/difw", checksumkind: CSK_MD5, checksum: "831cddc8d30b8440d08abf259b4c92fa")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 5447, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "e35b163ac757a706afe87c4e3c9d01d2")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !{!15, !0, !21}
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 61, type: !17, isLocal: false, isDefinition: true)
!17 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 32, elements: !19)
!18 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!19 = !{!20}
!20 = !DISubrange(count: 4)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !23, line: 1295, type: !24, isLocal: true, isDefinition: true)
!23 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "eadf4a8bcf7ac4e7bd6d2cb666452242")
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!25 = !DISubroutineType(types: !26)
!26 = !{!27, !28, !29, !31}
!27 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !30, line: 27, baseType: !7)
!30 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !30, line: 31, baseType: !32)
!32 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 33, size: 256, elements: !34)
!34 = !{!35, !41, !44, !45}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !33, file: !3, line: 35, baseType: !36, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 448, elements: !39)
!38 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!39 = !{!40}
!40 = !DISubrange(count: 14)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !33, file: !3, line: 36, baseType: !42, size: 64, offset: 64)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 128, elements: !19)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !33, file: !3, line: 37, baseType: !42, size: 64, offset: 128)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !33, file: !3, line: 38, baseType: !46, size: 64, offset: 192)
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 64, elements: !48)
!48 = !{!49}
!49 = !DISubrange(count: 2)
!50 = !{i32 7, !"Dwarf Version", i32 5}
!51 = !{i32 2, !"Debug Info Version", i32 3}
!52 = !{i32 1, !"wchar_size", i32 4}
!53 = !{i32 7, !"frame-pointer", i32 2}
!54 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!55 = distinct !DISubprogram(name: "diwf", scope: !3, file: !3, line: 42, type: !56, scopeLine: 43, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !67)
!56 = !DISubroutineType(types: !57)
!57 = !{!38, !58}
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!59 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 5458, size: 192, elements: !60)
!60 = !{!61, !62, !63, !64, !65, !66}
!61 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !59, file: !6, line: 5459, baseType: !29, size: 32)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !59, file: !6, line: 5460, baseType: !29, size: 32, offset: 32)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !59, file: !6, line: 5461, baseType: !29, size: 32, offset: 64)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !59, file: !6, line: 5463, baseType: !29, size: 32, offset: 96)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !59, file: !6, line: 5464, baseType: !29, size: 32, offset: 128)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !59, file: !6, line: 5466, baseType: !29, size: 32, offset: 160)
!67 = !{!68, !69, !70}
!68 = !DILocalVariable(name: "ctx", arg: 1, scope: !55, file: !3, line: 42, type: !58)
!69 = !DILocalVariable(name: "in_ifindex", scope: !55, file: !3, line: 44, type: !29)
!70 = !DILocalVariable(name: "out_ifindex", scope: !55, file: !3, line: 45, type: !29)
!71 = !DILocation(line: 0, scope: !55)
!72 = !DILocation(line: 44, column: 29, scope: !55)
!73 = !{!74, !75, i64 12}
!74 = !{!"xdp_md", !75, i64 0, !75, i64 4, !75, i64 8, !75, i64 12, !75, i64 16, !75, i64 20}
!75 = !{!"int", !76, i64 0}
!76 = !{!"omnipotent char", !77, i64 0}
!77 = !{!"Simple C/C++ TBAA"}
!78 = !DILocation(line: 48, column: 9, scope: !55)
!79 = !DILocation(line: 0, scope: !80)
!80 = distinct !DILexicalBlock(scope: !55, file: !3, line: 48, column: 9)
!81 = !DILocation(line: 55, column: 9, scope: !82)
!82 = distinct !DILexicalBlock(scope: !55, file: !3, line: 55, column: 9)
!83 = !DILocation(line: 55, column: 57, scope: !82)
!84 = !DILocation(line: 59, column: 1, scope: !55)
