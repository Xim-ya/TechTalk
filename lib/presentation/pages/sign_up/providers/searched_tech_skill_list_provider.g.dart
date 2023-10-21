// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searched_tech_skill_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchedTechSkillListHash() =>
    r'e2082cf6a1bc6db5bea24c2882a0a7f2bfd1bbce';

/// See also [searchedTechSkillList].
@ProviderFor(searchedTechSkillList)
final searchedTechSkillListProvider =
    AutoDisposeFutureProvider<List<TechSkillEntity>>.internal(
  searchedTechSkillList,
  name: r'searchedTechSkillListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchedTechSkillListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SearchedTechSkillListRef
    = AutoDisposeFutureProviderRef<List<TechSkillEntity>>;
String _$techSkillSearchKeywordHash() =>
    r'f4313a35710899a053698db3b8b8acc8a6b45b49';

/// See also [TechSkillSearchKeyword].
@ProviderFor(TechSkillSearchKeyword)
final techSkillSearchKeywordProvider =
    AutoDisposeNotifierProvider<TechSkillSearchKeyword, String>.internal(
  TechSkillSearchKeyword.new,
  name: r'techSkillSearchKeywordProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$techSkillSearchKeywordHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TechSkillSearchKeyword = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
