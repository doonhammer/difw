; ModuleID = 'src/ebpf/difw_kern.c'
source_filename = "src/ebpf/difw_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.anon.0 = type { ptr, ptr, ptr, ptr }
%struct.session_key = type { i32, i32, i16, i16, i8 }
%struct.session_info = type { i64, i64, i64 }
%struct.xdp_md = type { i32, i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@xdp_tx_ports = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !59
@sessions = dso_local global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !65
@llvm.compiler.used = appending global [4 x ptr] [ptr @_license, ptr @difw, ptr @sessions, ptr @xdp_tx_ports], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @difw(ptr nocapture noundef readonly %0) #0 section "xdp" !dbg !137 {
  %2 = alloca %struct.session_key, align 4, !DIAssignID !155
  %3 = alloca %struct.session_info, align 8, !DIAssignID !156
  tail call void @llvm.dbg.value(metadata ptr %0, metadata !151, metadata !DIExpression()), !dbg !157
  %4 = getelementptr inbounds %struct.xdp_md, ptr %0, i64 0, i32 3, !dbg !158
  %5 = load i32, ptr %4, align 4, !dbg !158, !tbaa !159
  tail call void @llvm.dbg.value(metadata i32 %5, metadata !152, metadata !DIExpression()), !dbg !157
  call void @llvm.dbg.assign(metadata i1 undef, metadata !164, metadata !DIExpression(), metadata !155, metadata ptr %2, metadata !DIExpression()), !dbg !264
  call void @llvm.dbg.assign(metadata i1 undef, metadata !256, metadata !DIExpression(), metadata !156, metadata ptr %3, metadata !DIExpression()), !dbg !264
  call void @llvm.dbg.value(metadata ptr %0, metadata !167, metadata !DIExpression()), !dbg !264
  %6 = getelementptr inbounds %struct.xdp_md, ptr %0, i64 0, i32 1, !dbg !266
  %7 = load i32, ptr %6, align 4, !dbg !266, !tbaa !267
  %8 = zext i32 %7 to i64, !dbg !268
  %9 = inttoptr i64 %8 to ptr, !dbg !269
  call void @llvm.dbg.value(metadata ptr %9, metadata !168, metadata !DIExpression()), !dbg !264
  %10 = load i32, ptr %0, align 4, !dbg !270, !tbaa !271
  %11 = zext i32 %10 to i64, !dbg !272
  %12 = inttoptr i64 %11 to ptr, !dbg !273
  call void @llvm.dbg.value(metadata ptr %12, metadata !169, metadata !DIExpression()), !dbg !264
  call void @llvm.dbg.value(metadata ptr %12, metadata !170, metadata !DIExpression()), !dbg !264
  %13 = getelementptr inbounds %struct.ethhdr, ptr %12, i64 1, !dbg !274
  %14 = icmp ugt ptr %13, %9, !dbg !276
  br i1 %14, label %65, label %15, !dbg !277

15:                                               ; preds = %1
  %16 = getelementptr inbounds %struct.ethhdr, ptr %12, i64 0, i32 2, !dbg !278
  %17 = load i16, ptr %16, align 1, !dbg !278, !tbaa !280
  %18 = icmp eq i16 %17, 8, !dbg !283
  br i1 %18, label %19, label %65, !dbg !284

19:                                               ; preds = %15
  call void @llvm.dbg.value(metadata ptr %13, metadata !184, metadata !DIExpression()), !dbg !264
  %20 = getelementptr inbounds %struct.ethhdr, ptr %12, i64 2, i32 1, !dbg !285
  %21 = icmp ugt ptr %20, %9, !dbg !287
  br i1 %21, label %65, label %22, !dbg !288

22:                                               ; preds = %19
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %2) #4, !dbg !289
  %23 = getelementptr inbounds i8, ptr %2, i64 8, !dbg !290
  store i64 0, ptr %23, align 4, !dbg !290, !DIAssignID !291
  call void @llvm.dbg.assign(metadata i64 0, metadata !164, metadata !DIExpression(), metadata !291, metadata ptr %2, metadata !DIExpression()), !dbg !264
  call void @llvm.dbg.assign(metadata i8 0, metadata !164, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64), metadata !292, metadata ptr undef, metadata !DIExpression()), !dbg !264
  %24 = getelementptr inbounds %struct.ethhdr, ptr %12, i64 1, i32 2, !dbg !293
  %25 = load i32, ptr %24, align 4, !dbg !293, !tbaa !294
  store i32 %25, ptr %2, align 4, !dbg !295, !tbaa !296, !DIAssignID !298
  call void @llvm.dbg.assign(metadata i32 %25, metadata !164, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32), metadata !298, metadata ptr %2, metadata !DIExpression()), !dbg !264
  %26 = getelementptr inbounds %struct.ethhdr, ptr %12, i64 2, i32 0, i64 2, !dbg !299
  %27 = load i32, ptr %26, align 4, !dbg !299, !tbaa !294
  %28 = getelementptr inbounds %struct.session_key, ptr %2, i64 0, i32 1, !dbg !300
  store i32 %27, ptr %28, align 4, !dbg !301, !tbaa !302, !DIAssignID !303
  call void @llvm.dbg.assign(metadata i32 %27, metadata !164, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32), metadata !303, metadata ptr %28, metadata !DIExpression()), !dbg !264
  %29 = getelementptr inbounds %struct.ethhdr, ptr %12, i64 1, i32 1, i64 3, !dbg !304
  %30 = load i8, ptr %29, align 1, !dbg !304, !tbaa !305
  %31 = getelementptr inbounds %struct.session_key, ptr %2, i64 0, i32 4, !dbg !307
  store i8 %30, ptr %31, align 4, !dbg !308, !tbaa !309, !DIAssignID !310
  call void @llvm.dbg.assign(metadata i8 %30, metadata !164, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 8), metadata !310, metadata ptr %31, metadata !DIExpression()), !dbg !264
  switch i8 %30, label %64 [
    i8 6, label %32
    i8 17, label %35
  ], !dbg !311

32:                                               ; preds = %22
  call void @llvm.dbg.value(metadata ptr %20, metadata !214, metadata !DIExpression()), !dbg !312
  %33 = getelementptr inbounds %struct.ethhdr, ptr %12, i64 3, i32 2, !dbg !313
  %34 = icmp ugt ptr %33, %9, !dbg !315
  br i1 %34, label %64, label %38, !dbg !316

35:                                               ; preds = %22
  call void @llvm.dbg.value(metadata ptr %20, metadata !238, metadata !DIExpression()), !dbg !317
  %36 = getelementptr inbounds %struct.ethhdr, ptr %12, i64 3, !dbg !318
  %37 = icmp ugt ptr %36, %9, !dbg !320
  br i1 %37, label %64, label %38, !dbg !321

38:                                               ; preds = %35, %32
  %39 = load i16, ptr %20, align 2, !dbg !322, !tbaa !323
  %40 = tail call i16 @llvm.bswap.i16(i16 %39), !dbg !322
  %41 = getelementptr inbounds %struct.session_key, ptr %2, i64 0, i32 2, !dbg !322
  store i16 %40, ptr %41, align 4, !dbg !322, !tbaa !324, !DIAssignID !325
  %42 = getelementptr inbounds %struct.ethhdr, ptr %12, i64 2, i32 1, i64 2, !dbg !322
  %43 = load i16, ptr %42, align 2, !dbg !322, !tbaa !323
  %44 = tail call i16 @llvm.bswap.i16(i16 %43), !dbg !322
  %45 = getelementptr inbounds %struct.session_key, ptr %2, i64 0, i32 3, !dbg !322
  store i16 %44, ptr %45, align 2, !dbg !322, !tbaa !326, !DIAssignID !327
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %3) #4, !dbg !328
  call void @llvm.dbg.assign(metadata i8 0, metadata !256, metadata !DIExpression(), metadata !329, metadata ptr %3, metadata !DIExpression()), !dbg !264
  %46 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @sessions, ptr noundef nonnull %2) #4, !dbg !330
  call void @llvm.dbg.value(metadata ptr %46, metadata !249, metadata !DIExpression()), !dbg !264
  %47 = icmp eq ptr %46, null, !dbg !331
  br i1 %47, label %48, label %54, !dbg !333

48:                                               ; preds = %38
  store i64 1, ptr %3, align 8, !dbg !334, !tbaa !336, !DIAssignID !339
  call void @llvm.dbg.assign(metadata i64 1, metadata !256, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64), metadata !339, metadata ptr %3, metadata !DIExpression()), !dbg !264
  %49 = sub nsw i64 %8, %11, !dbg !340
  %50 = getelementptr inbounds %struct.session_info, ptr %3, i64 0, i32 1, !dbg !341
  store i64 %49, ptr %50, align 8, !dbg !342, !tbaa !343, !DIAssignID !344
  call void @llvm.dbg.assign(metadata i64 %49, metadata !256, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64), metadata !344, metadata ptr %50, metadata !DIExpression()), !dbg !264
  %51 = call i64 inttoptr (i64 5 to ptr)() #4, !dbg !345
  %52 = getelementptr inbounds %struct.session_info, ptr %3, i64 0, i32 2, !dbg !346
  store i64 %51, ptr %52, align 8, !dbg !347, !tbaa !348, !DIAssignID !349
  call void @llvm.dbg.assign(metadata i64 %51, metadata !256, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64), metadata !349, metadata ptr %52, metadata !DIExpression()), !dbg !264
  %53 = call i64 inttoptr (i64 2 to ptr)(ptr noundef nonnull @sessions, ptr noundef nonnull %2, ptr noundef nonnull %3, i64 noundef 0) #4, !dbg !350
  br label %63, !dbg !351

54:                                               ; preds = %38
  %55 = load i64, ptr %46, align 8, !dbg !352, !tbaa !336
  %56 = add i64 %55, 1, !dbg !352
  store i64 %56, ptr %46, align 8, !dbg !352, !tbaa !336
  %57 = sub nsw i64 %8, %11, !dbg !354
  %58 = getelementptr inbounds %struct.session_info, ptr %46, i64 0, i32 1, !dbg !355
  %59 = load i64, ptr %58, align 8, !dbg !356, !tbaa !343
  %60 = add i64 %57, %59, !dbg !356
  store i64 %60, ptr %58, align 8, !dbg !356, !tbaa !343
  %61 = call i64 inttoptr (i64 5 to ptr)() #4, !dbg !357
  %62 = getelementptr inbounds %struct.session_info, ptr %46, i64 0, i32 2, !dbg !358
  store i64 %61, ptr %62, align 8, !dbg !359, !tbaa !348
  br label %63

63:                                               ; preds = %54, %48
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %3) #4, !dbg !360
  br label %64

64:                                               ; preds = %63, %35, %32, %22
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %2) #4, !dbg !360
  br label %65

65:                                               ; preds = %1, %15, %19, %64
  tail call void @llvm.dbg.value(metadata i32 2, metadata !154, metadata !DIExpression()), !dbg !157
  switch i32 %5, label %72 [
    i32 1, label %67
    i32 2, label %66
  ], !dbg !361

66:                                               ; preds = %65
  tail call void @llvm.dbg.value(metadata i32 1, metadata !153, metadata !DIExpression()), !dbg !157
  br label %67

67:                                               ; preds = %65, %66
  %68 = phi i64 [ 1, %66 ], [ 2, %65 ], !dbg !362
  tail call void @llvm.dbg.value(metadata i64 %68, metadata !153, metadata !DIExpression()), !dbg !157
  %69 = call i64 inttoptr (i64 51 to ptr)(ptr noundef nonnull @xdp_tx_ports, i64 noundef %68, i64 noundef 0) #4, !dbg !364
  %70 = icmp slt i64 %69, 0, !dbg !366
  %71 = select i1 %70, i32 1, i32 4, !dbg !157
  br label %72, !dbg !157

72:                                               ; preds = %67, %65
  %73 = phi i32 [ 2, %65 ], [ %71, %67 ], !dbg !157
  ret i32 %73, !dbg !367
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.bswap.i16(i16) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.assign(metadata, metadata, metadata, metadata, metadata, metadata) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.value(metadata, metadata, metadata) #3

attributes #0 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!131, !132, !133, !134, !135}
!llvm.ident = !{!136}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_tx_ports", scope: !2, file: !3, line: 55, type: !115, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !52, globals: !58, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "src/ebpf/difw_kern.c", directory: "/media/psf/Home/Development/vagrant/repository/code/go/src/difw", checksumkind: CSK_MD5, checksum: "ade44726e3de9acf839a742dbe85ecf8")
!4 = !{!5, !14, !46}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 6337, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "138cb73eb42942499c5a2382b1dd0dc0")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !15, line: 29, baseType: !7, size: 32, elements: !16)
!15 = !DIFile(filename: "/usr/include/linux/in.h", directory: "", checksumkind: CSK_MD5, checksum: "fcee415bb19db8acb968eeda6f02fa29")
!16 = !{!17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44, !45}
!17 = !DIEnumerator(name: "IPPROTO_IP", value: 0)
!18 = !DIEnumerator(name: "IPPROTO_ICMP", value: 1)
!19 = !DIEnumerator(name: "IPPROTO_IGMP", value: 2)
!20 = !DIEnumerator(name: "IPPROTO_IPIP", value: 4)
!21 = !DIEnumerator(name: "IPPROTO_TCP", value: 6)
!22 = !DIEnumerator(name: "IPPROTO_EGP", value: 8)
!23 = !DIEnumerator(name: "IPPROTO_PUP", value: 12)
!24 = !DIEnumerator(name: "IPPROTO_UDP", value: 17)
!25 = !DIEnumerator(name: "IPPROTO_IDP", value: 22)
!26 = !DIEnumerator(name: "IPPROTO_TP", value: 29)
!27 = !DIEnumerator(name: "IPPROTO_DCCP", value: 33)
!28 = !DIEnumerator(name: "IPPROTO_IPV6", value: 41)
!29 = !DIEnumerator(name: "IPPROTO_RSVP", value: 46)
!30 = !DIEnumerator(name: "IPPROTO_GRE", value: 47)
!31 = !DIEnumerator(name: "IPPROTO_ESP", value: 50)
!32 = !DIEnumerator(name: "IPPROTO_AH", value: 51)
!33 = !DIEnumerator(name: "IPPROTO_MTP", value: 92)
!34 = !DIEnumerator(name: "IPPROTO_BEETPH", value: 94)
!35 = !DIEnumerator(name: "IPPROTO_ENCAP", value: 98)
!36 = !DIEnumerator(name: "IPPROTO_PIM", value: 103)
!37 = !DIEnumerator(name: "IPPROTO_COMP", value: 108)
!38 = !DIEnumerator(name: "IPPROTO_L2TP", value: 115)
!39 = !DIEnumerator(name: "IPPROTO_SCTP", value: 132)
!40 = !DIEnumerator(name: "IPPROTO_UDPLITE", value: 136)
!41 = !DIEnumerator(name: "IPPROTO_MPLS", value: 137)
!42 = !DIEnumerator(name: "IPPROTO_ETHERNET", value: 143)
!43 = !DIEnumerator(name: "IPPROTO_RAW", value: 255)
!44 = !DIEnumerator(name: "IPPROTO_MPTCP", value: 262)
!45 = !DIEnumerator(name: "IPPROTO_MAX", value: 263)
!46 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 1299, baseType: !7, size: 32, elements: !47)
!47 = !{!48, !49, !50, !51}
!48 = !DIEnumerator(name: "BPF_ANY", value: 0)
!49 = !DIEnumerator(name: "BPF_NOEXIST", value: 1)
!50 = !DIEnumerator(name: "BPF_EXIST", value: 2)
!51 = !DIEnumerator(name: "BPF_F_LOCK", value: 4)
!52 = !{!53, !54, !55}
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!54 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !56, line: 24, baseType: !57)
!56 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!57 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!58 = !{!59, !0, !65, !90, !98, !105, !110}
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 141, type: !61, isLocal: false, isDefinition: true)
!61 = !DICompositeType(tag: DW_TAG_array_type, baseType: !62, size: 32, elements: !63)
!62 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!63 = !{!64}
!64 = !DISubrange(count: 4)
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(name: "sessions", scope: !2, file: !3, line: 62, type: !67, isLocal: false, isDefinition: true)
!67 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 57, size: 256, elements: !68)
!68 = !{!69, !75, !80, !85}
!69 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !67, file: !3, line: 58, baseType: !70, size: 64)
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!71 = !DICompositeType(tag: DW_TAG_array_type, baseType: !72, size: 32, elements: !73)
!72 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!73 = !{!74}
!74 = !DISubrange(count: 1)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !67, file: !3, line: 59, baseType: !76, size: 64, offset: 64)
!76 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !77, size: 64)
!77 = !DICompositeType(tag: DW_TAG_array_type, baseType: !72, size: 512, elements: !78)
!78 = !{!79}
!79 = !DISubrange(count: 16)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !67, file: !3, line: 60, baseType: !81, size: 64, offset: 128)
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!82 = !DICompositeType(tag: DW_TAG_array_type, baseType: !72, size: 768, elements: !83)
!83 = !{!84}
!84 = !DISubrange(count: 24)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !67, file: !3, line: 61, baseType: !86, size: 64, offset: 192)
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = !DICompositeType(tag: DW_TAG_array_type, baseType: !72, size: 320000, elements: !88)
!88 = !{!89}
!89 = !DISubrange(count: 10000)
!90 = !DIGlobalVariableExpression(var: !91, expr: !DIExpression(DW_OP_constu, 1, DW_OP_stack_value))
!91 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !92, line: 56, type: !93, isLocal: true, isDefinition: true)
!92 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "09cfcd7169c24bec448f30582e8c6db9")
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = !DISubroutineType(types: !95)
!95 = !{!53, !53, !96}
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!98 = !DIGlobalVariableExpression(var: !99, expr: !DIExpression(DW_OP_constu, 5, DW_OP_stack_value))
!99 = distinct !DIGlobalVariable(name: "bpf_ktime_get_ns", scope: !2, file: !92, line: 114, type: !100, isLocal: true, isDefinition: true)
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!101 = !DISubroutineType(types: !102)
!102 = !{!103}
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !56, line: 31, baseType: !104)
!104 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!105 = !DIGlobalVariableExpression(var: !106, expr: !DIExpression(DW_OP_constu, 2, DW_OP_stack_value))
!106 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !92, line: 78, type: !107, isLocal: true, isDefinition: true)
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 64)
!108 = !DISubroutineType(types: !109)
!109 = !{!54, !53, !96, !96, !103}
!110 = !DIGlobalVariableExpression(var: !111, expr: !DIExpression(DW_OP_constu, 51, DW_OP_stack_value))
!111 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !92, line: 1325, type: !112, isLocal: true, isDefinition: true)
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = !DISubroutineType(types: !114)
!114 = !{!54, !53, !103, !103}
!115 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 50, size: 256, elements: !116)
!116 = !{!117, !122, !125, !126}
!117 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !115, file: !3, line: 51, baseType: !118, size: 64)
!118 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !119, size: 64)
!119 = !DICompositeType(tag: DW_TAG_array_type, baseType: !72, size: 448, elements: !120)
!120 = !{!121}
!121 = !DISubrange(count: 14)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !115, file: !3, line: 52, baseType: !123, size: 64, offset: 64)
!123 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !124, size: 64)
!124 = !DICompositeType(tag: DW_TAG_array_type, baseType: !72, size: 128, elements: !63)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !115, file: !3, line: 53, baseType: !123, size: 64, offset: 128)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !115, file: !3, line: 54, baseType: !127, size: 64, offset: 192)
!127 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !128, size: 64)
!128 = !DICompositeType(tag: DW_TAG_array_type, baseType: !72, size: 64, elements: !129)
!129 = !{!130}
!130 = !DISubrange(count: 2)
!131 = !{i32 7, !"Dwarf Version", i32 5}
!132 = !{i32 2, !"Debug Info Version", i32 3}
!133 = !{i32 1, !"wchar_size", i32 4}
!134 = !{i32 7, !"frame-pointer", i32 2}
!135 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!136 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!137 = distinct !DISubprogram(name: "difw", scope: !3, file: !3, line: 117, type: !138, scopeLine: 118, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !150)
!138 = !DISubroutineType(types: !139)
!139 = !{!72, !140}
!140 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !141, size: 64)
!141 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 6348, size: 192, elements: !142)
!142 = !{!143, !145, !146, !147, !148, !149}
!143 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !141, file: !6, line: 6349, baseType: !144, size: 32)
!144 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !56, line: 27, baseType: !7)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !141, file: !6, line: 6350, baseType: !144, size: 32, offset: 32)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !141, file: !6, line: 6351, baseType: !144, size: 32, offset: 64)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !141, file: !6, line: 6353, baseType: !144, size: 32, offset: 96)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !141, file: !6, line: 6354, baseType: !144, size: 32, offset: 128)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !141, file: !6, line: 6356, baseType: !144, size: 32, offset: 160)
!150 = !{!151, !152, !153, !154}
!151 = !DILocalVariable(name: "ctx", arg: 1, scope: !137, file: !3, line: 117, type: !140)
!152 = !DILocalVariable(name: "in_ifindex", scope: !137, file: !3, line: 119, type: !144)
!153 = !DILocalVariable(name: "out_ifindex", scope: !137, file: !3, line: 120, type: !144)
!154 = !DILocalVariable(name: "action", scope: !137, file: !3, line: 123, type: !72)
!155 = distinct !DIAssignID()
!156 = distinct !DIAssignID()
!157 = !DILocation(line: 0, scope: !137)
!158 = !DILocation(line: 119, column: 29, scope: !137)
!159 = !{!160, !161, i64 12}
!160 = !{!"xdp_md", !161, i64 0, !161, i64 4, !161, i64 8, !161, i64 12, !161, i64 16, !161, i64 20}
!161 = !{!"int", !162, i64 0}
!162 = !{!"omnipotent char", !163, i64 0}
!163 = !{!"Simple C/C++ TBAA"}
!164 = !DILocalVariable(name: "key", scope: !165, file: !3, line: 79, type: !257)
!165 = distinct !DISubprogram(name: "process_packet", scope: !3, file: !3, line: 64, type: !138, scopeLine: 64, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !166)
!166 = !{!167, !168, !169, !170, !184, !164, !214, !238, !249, !256}
!167 = !DILocalVariable(name: "ctx", arg: 1, scope: !165, file: !3, line: 64, type: !140)
!168 = !DILocalVariable(name: "data_end", scope: !165, file: !3, line: 65, type: !53)
!169 = !DILocalVariable(name: "data", scope: !165, file: !3, line: 66, type: !53)
!170 = !DILocalVariable(name: "eth", scope: !165, file: !3, line: 68, type: !171)
!171 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !172, size: 64)
!172 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !173, line: 173, size: 112, elements: !174)
!173 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!174 = !{!175, !180, !181}
!175 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !172, file: !173, line: 174, baseType: !176, size: 48)
!176 = !DICompositeType(tag: DW_TAG_array_type, baseType: !177, size: 48, elements: !178)
!177 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!178 = !{!179}
!179 = !DISubrange(count: 6)
!180 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !172, file: !173, line: 175, baseType: !176, size: 48, offset: 48)
!181 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !172, file: !173, line: 176, baseType: !182, size: 16, offset: 96)
!182 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !183, line: 32, baseType: !55)
!183 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "bf9fbc0e8f60927fef9d8917535375a6")
!184 = !DILocalVariable(name: "iph", scope: !165, file: !3, line: 75, type: !185)
!185 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !186, size: 64)
!186 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !187, line: 87, size: 160, elements: !188)
!187 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "149778ace30a1ff208adc8783fd04b29")
!188 = !{!189, !191, !192, !193, !194, !195, !196, !197, !198, !200}
!189 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !186, file: !187, line: 89, baseType: !190, size: 4, flags: DIFlagBitField, extraData: i64 0)
!190 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !56, line: 21, baseType: !177)
!191 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !186, file: !187, line: 90, baseType: !190, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!192 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !186, file: !187, line: 97, baseType: !190, size: 8, offset: 8)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !186, file: !187, line: 98, baseType: !182, size: 16, offset: 16)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !186, file: !187, line: 99, baseType: !182, size: 16, offset: 32)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !186, file: !187, line: 100, baseType: !182, size: 16, offset: 48)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !186, file: !187, line: 101, baseType: !190, size: 8, offset: 64)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !186, file: !187, line: 102, baseType: !190, size: 8, offset: 72)
!198 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !186, file: !187, line: 103, baseType: !199, size: 16, offset: 80)
!199 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !183, line: 38, baseType: !55)
!200 = !DIDerivedType(tag: DW_TAG_member, scope: !186, file: !187, line: 104, baseType: !201, size: 64, offset: 96)
!201 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !186, file: !187, line: 104, size: 64, elements: !202)
!202 = !{!203, !209}
!203 = !DIDerivedType(tag: DW_TAG_member, scope: !201, file: !187, line: 104, baseType: !204, size: 64)
!204 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !201, file: !187, line: 104, size: 64, elements: !205)
!205 = !{!206, !208}
!206 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !204, file: !187, line: 104, baseType: !207, size: 32)
!207 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !183, line: 34, baseType: !144)
!208 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !204, file: !187, line: 104, baseType: !207, size: 32, offset: 32)
!209 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !201, file: !187, line: 104, baseType: !210, size: 64)
!210 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !201, file: !187, line: 104, size: 64, elements: !211)
!211 = !{!212, !213}
!212 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !210, file: !187, line: 104, baseType: !207, size: 32)
!213 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !210, file: !187, line: 104, baseType: !207, size: 32, offset: 32)
!214 = !DILocalVariable(name: "tcp", scope: !215, file: !3, line: 85, type: !217)
!215 = distinct !DILexicalBlock(scope: !216, file: !3, line: 84, column: 39)
!216 = distinct !DILexicalBlock(scope: !165, file: !3, line: 84, column: 9)
!217 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !218, size: 64)
!218 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcphdr", file: !219, line: 25, size: 160, elements: !220)
!219 = !DIFile(filename: "/usr/include/linux/tcp.h", directory: "", checksumkind: CSK_MD5, checksum: "bd53e42c49642a86fd7da9761b6f86eb")
!220 = !{!221, !222, !223, !224, !225, !226, !227, !228, !229, !230, !231, !232, !233, !234, !235, !236, !237}
!221 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !218, file: !219, line: 26, baseType: !182, size: 16)
!222 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !218, file: !219, line: 27, baseType: !182, size: 16, offset: 16)
!223 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !218, file: !219, line: 28, baseType: !207, size: 32, offset: 32)
!224 = !DIDerivedType(tag: DW_TAG_member, name: "ack_seq", scope: !218, file: !219, line: 29, baseType: !207, size: 32, offset: 64)
!225 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !218, file: !219, line: 31, baseType: !55, size: 4, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!226 = !DIDerivedType(tag: DW_TAG_member, name: "doff", scope: !218, file: !219, line: 32, baseType: !55, size: 4, offset: 100, flags: DIFlagBitField, extraData: i64 96)
!227 = !DIDerivedType(tag: DW_TAG_member, name: "fin", scope: !218, file: !219, line: 33, baseType: !55, size: 1, offset: 104, flags: DIFlagBitField, extraData: i64 96)
!228 = !DIDerivedType(tag: DW_TAG_member, name: "syn", scope: !218, file: !219, line: 34, baseType: !55, size: 1, offset: 105, flags: DIFlagBitField, extraData: i64 96)
!229 = !DIDerivedType(tag: DW_TAG_member, name: "rst", scope: !218, file: !219, line: 35, baseType: !55, size: 1, offset: 106, flags: DIFlagBitField, extraData: i64 96)
!230 = !DIDerivedType(tag: DW_TAG_member, name: "psh", scope: !218, file: !219, line: 36, baseType: !55, size: 1, offset: 107, flags: DIFlagBitField, extraData: i64 96)
!231 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !218, file: !219, line: 37, baseType: !55, size: 1, offset: 108, flags: DIFlagBitField, extraData: i64 96)
!232 = !DIDerivedType(tag: DW_TAG_member, name: "urg", scope: !218, file: !219, line: 38, baseType: !55, size: 1, offset: 109, flags: DIFlagBitField, extraData: i64 96)
!233 = !DIDerivedType(tag: DW_TAG_member, name: "ece", scope: !218, file: !219, line: 39, baseType: !55, size: 1, offset: 110, flags: DIFlagBitField, extraData: i64 96)
!234 = !DIDerivedType(tag: DW_TAG_member, name: "cwr", scope: !218, file: !219, line: 40, baseType: !55, size: 1, offset: 111, flags: DIFlagBitField, extraData: i64 96)
!235 = !DIDerivedType(tag: DW_TAG_member, name: "window", scope: !218, file: !219, line: 55, baseType: !182, size: 16, offset: 112)
!236 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !218, file: !219, line: 56, baseType: !199, size: 16, offset: 128)
!237 = !DIDerivedType(tag: DW_TAG_member, name: "urg_ptr", scope: !218, file: !219, line: 57, baseType: !182, size: 16, offset: 144)
!238 = !DILocalVariable(name: "udp", scope: !239, file: !3, line: 91, type: !241)
!239 = distinct !DILexicalBlock(scope: !240, file: !3, line: 90, column: 46)
!240 = distinct !DILexicalBlock(scope: !216, file: !3, line: 90, column: 16)
!241 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !242, size: 64)
!242 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !243, line: 23, size: 64, elements: !244)
!243 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "", checksumkind: CSK_MD5, checksum: "53c0d42e1bf6d93b39151764be2d20fb")
!244 = !{!245, !246, !247, !248}
!245 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !242, file: !243, line: 24, baseType: !182, size: 16)
!246 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !242, file: !243, line: 25, baseType: !182, size: 16, offset: 16)
!247 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !242, file: !243, line: 26, baseType: !182, size: 16, offset: 32)
!248 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !242, file: !243, line: 27, baseType: !199, size: 16, offset: 48)
!249 = !DILocalVariable(name: "info", scope: !165, file: !3, line: 100, type: !250)
!250 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !251, size: 64)
!251 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "session_info", file: !3, line: 44, size: 192, elements: !252)
!252 = !{!253, !254, !255}
!253 = !DIDerivedType(tag: DW_TAG_member, name: "packets", scope: !251, file: !3, line: 45, baseType: !103, size: 64)
!254 = !DIDerivedType(tag: DW_TAG_member, name: "bytes", scope: !251, file: !3, line: 46, baseType: !103, size: 64, offset: 64)
!255 = !DIDerivedType(tag: DW_TAG_member, name: "timestamp", scope: !251, file: !3, line: 47, baseType: !103, size: 64, offset: 128)
!256 = !DILocalVariable(name: "new_info", scope: !165, file: !3, line: 100, type: !251)
!257 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "session_key", file: !3, line: 35, size: 128, elements: !258)
!258 = !{!259, !260, !261, !262, !263}
!259 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip", scope: !257, file: !3, line: 36, baseType: !144, size: 32)
!260 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip", scope: !257, file: !3, line: 37, baseType: !144, size: 32, offset: 32)
!261 = !DIDerivedType(tag: DW_TAG_member, name: "src_port", scope: !257, file: !3, line: 38, baseType: !55, size: 16, offset: 64)
!262 = !DIDerivedType(tag: DW_TAG_member, name: "dst_port", scope: !257, file: !3, line: 39, baseType: !55, size: 16, offset: 80)
!263 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !257, file: !3, line: 40, baseType: !190, size: 8, offset: 96)
!264 = !DILocation(line: 0, scope: !165, inlinedAt: !265)
!265 = distinct !DILocation(line: 123, column: 18, scope: !137)
!266 = !DILocation(line: 65, column: 41, scope: !165, inlinedAt: !265)
!267 = !{!160, !161, i64 4}
!268 = !DILocation(line: 65, column: 30, scope: !165, inlinedAt: !265)
!269 = !DILocation(line: 65, column: 22, scope: !165, inlinedAt: !265)
!270 = !DILocation(line: 66, column: 37, scope: !165, inlinedAt: !265)
!271 = !{!160, !161, i64 0}
!272 = !DILocation(line: 66, column: 26, scope: !165, inlinedAt: !265)
!273 = !DILocation(line: 66, column: 18, scope: !165, inlinedAt: !265)
!274 = !DILocation(line: 69, column: 21, scope: !275, inlinedAt: !265)
!275 = distinct !DILexicalBlock(scope: !165, file: !3, line: 69, column: 9)
!276 = !DILocation(line: 69, column: 26, scope: !275, inlinedAt: !265)
!277 = !DILocation(line: 69, column: 9, scope: !165, inlinedAt: !265)
!278 = !DILocation(line: 72, column: 14, scope: !279, inlinedAt: !265)
!279 = distinct !DILexicalBlock(scope: !165, file: !3, line: 72, column: 9)
!280 = !{!281, !282, i64 12}
!281 = !{!"ethhdr", !162, i64 0, !162, i64 6, !282, i64 12}
!282 = !{!"short", !162, i64 0}
!283 = !DILocation(line: 72, column: 22, scope: !279, inlinedAt: !265)
!284 = !DILocation(line: 72, column: 9, scope: !165, inlinedAt: !265)
!285 = !DILocation(line: 76, column: 21, scope: !286, inlinedAt: !265)
!286 = distinct !DILexicalBlock(scope: !165, file: !3, line: 76, column: 9)
!287 = !DILocation(line: 76, column: 26, scope: !286, inlinedAt: !265)
!288 = !DILocation(line: 76, column: 9, scope: !165, inlinedAt: !265)
!289 = !DILocation(line: 79, column: 5, scope: !165, inlinedAt: !265)
!290 = !DILocation(line: 79, column: 24, scope: !165, inlinedAt: !265)
!291 = distinct !DIAssignID()
!292 = distinct !DIAssignID()
!293 = !DILocation(line: 80, column: 23, scope: !165, inlinedAt: !265)
!294 = !{!162, !162, i64 0}
!295 = !DILocation(line: 80, column: 16, scope: !165, inlinedAt: !265)
!296 = !{!297, !161, i64 0}
!297 = !{!"session_key", !161, i64 0, !161, i64 4, !282, i64 8, !282, i64 10, !162, i64 12}
!298 = distinct !DIAssignID()
!299 = !DILocation(line: 81, column: 23, scope: !165, inlinedAt: !265)
!300 = !DILocation(line: 81, column: 9, scope: !165, inlinedAt: !265)
!301 = !DILocation(line: 81, column: 16, scope: !165, inlinedAt: !265)
!302 = !{!297, !161, i64 4}
!303 = distinct !DIAssignID()
!304 = !DILocation(line: 82, column: 25, scope: !165, inlinedAt: !265)
!305 = !{!306, !162, i64 9}
!306 = !{!"iphdr", !162, i64 0, !162, i64 0, !162, i64 1, !282, i64 2, !282, i64 4, !282, i64 6, !162, i64 8, !162, i64 9, !282, i64 10, !162, i64 12}
!307 = !DILocation(line: 82, column: 9, scope: !165, inlinedAt: !265)
!308 = !DILocation(line: 82, column: 18, scope: !165, inlinedAt: !265)
!309 = !{!297, !162, i64 12}
!310 = distinct !DIAssignID()
!311 = !DILocation(line: 84, column: 9, scope: !165, inlinedAt: !265)
!312 = !DILocation(line: 0, scope: !215, inlinedAt: !265)
!313 = !DILocation(line: 86, column: 25, scope: !314, inlinedAt: !265)
!314 = distinct !DILexicalBlock(scope: !215, file: !3, line: 86, column: 13)
!315 = !DILocation(line: 86, column: 30, scope: !314, inlinedAt: !265)
!316 = !DILocation(line: 86, column: 13, scope: !215, inlinedAt: !265)
!317 = !DILocation(line: 0, scope: !239, inlinedAt: !265)
!318 = !DILocation(line: 92, column: 25, scope: !319, inlinedAt: !265)
!319 = distinct !DILexicalBlock(scope: !239, file: !3, line: 92, column: 13)
!320 = !DILocation(line: 92, column: 30, scope: !319, inlinedAt: !265)
!321 = !DILocation(line: 92, column: 13, scope: !239, inlinedAt: !265)
!322 = !DILocation(line: 0, scope: !216, inlinedAt: !265)
!323 = !{!282, !282, i64 0}
!324 = !{!297, !282, i64 8}
!325 = distinct !DIAssignID()
!326 = !{!297, !282, i64 10}
!327 = distinct !DIAssignID()
!328 = !DILocation(line: 100, column: 5, scope: !165, inlinedAt: !265)
!329 = distinct !DIAssignID()
!330 = !DILocation(line: 101, column: 12, scope: !165, inlinedAt: !265)
!331 = !DILocation(line: 102, column: 10, scope: !332, inlinedAt: !265)
!332 = distinct !DILexicalBlock(scope: !165, file: !3, line: 102, column: 9)
!333 = !DILocation(line: 102, column: 9, scope: !165, inlinedAt: !265)
!334 = !DILocation(line: 103, column: 26, scope: !335, inlinedAt: !265)
!335 = distinct !DILexicalBlock(scope: !332, file: !3, line: 102, column: 16)
!336 = !{!337, !338, i64 0}
!337 = !{!"session_info", !338, i64 0, !338, i64 8, !338, i64 16}
!338 = !{!"long long", !162, i64 0}
!339 = distinct !DIAssignID()
!340 = !DILocation(line: 104, column: 36, scope: !335, inlinedAt: !265)
!341 = !DILocation(line: 104, column: 18, scope: !335, inlinedAt: !265)
!342 = !DILocation(line: 104, column: 24, scope: !335, inlinedAt: !265)
!343 = !{!337, !338, i64 8}
!344 = distinct !DIAssignID()
!345 = !DILocation(line: 105, column: 30, scope: !335, inlinedAt: !265)
!346 = !DILocation(line: 105, column: 18, scope: !335, inlinedAt: !265)
!347 = !DILocation(line: 105, column: 28, scope: !335, inlinedAt: !265)
!348 = !{!337, !338, i64 16}
!349 = distinct !DIAssignID()
!350 = !DILocation(line: 106, column: 9, scope: !335, inlinedAt: !265)
!351 = !DILocation(line: 107, column: 5, scope: !335, inlinedAt: !265)
!352 = !DILocation(line: 108, column: 22, scope: !353, inlinedAt: !265)
!353 = distinct !DILexicalBlock(scope: !332, file: !3, line: 107, column: 12)
!354 = !DILocation(line: 109, column: 34, scope: !353, inlinedAt: !265)
!355 = !DILocation(line: 109, column: 15, scope: !353, inlinedAt: !265)
!356 = !DILocation(line: 109, column: 21, scope: !353, inlinedAt: !265)
!357 = !DILocation(line: 110, column: 27, scope: !353, inlinedAt: !265)
!358 = !DILocation(line: 110, column: 15, scope: !353, inlinedAt: !265)
!359 = !DILocation(line: 110, column: 25, scope: !353, inlinedAt: !265)
!360 = !DILocation(line: 114, column: 1, scope: !165, inlinedAt: !265)
!361 = !DILocation(line: 128, column: 9, scope: !137)
!362 = !DILocation(line: 0, scope: !363)
!363 = distinct !DILexicalBlock(scope: !137, file: !3, line: 128, column: 9)
!364 = !DILocation(line: 135, column: 9, scope: !365)
!365 = distinct !DILexicalBlock(scope: !137, file: !3, line: 135, column: 9)
!366 = !DILocation(line: 135, column: 57, scope: !365)
!367 = !DILocation(line: 139, column: 1, scope: !137)
