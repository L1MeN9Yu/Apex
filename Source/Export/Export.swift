//
// Created by Mengyu Li on 2020/1/30.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

/* Copyright (c) 2011 The LevelDB Authors. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file. See the AUTHORS file for names of contributors.

  C bindings for leveldb.  May be useful as a stable ABI that can be
  used by programs that keep leveldb in a shared library, or for
  a JNI api.

  Does not support:
  . getters for the option types
  . custom comparators that implement key shortening
  . custom iter, db, env, cache implementations using just the C bindings

  Some conventions:

  (1) We expose just opaque struct pointers and functions to clients.
  This allows us to change internal representations without having to
  recompile clients.

  (2) For simplicity, there is no equivalent to the Slice type.  Instead,
  the caller has to pass the pointer and length as separate
  arguments.

  (3) Errors are represented by a null-terminated c string.  NULL
  means no error.  All operations that can raise an error are passed
  a "char** errptr" as the last argument.  One of the following must
  be true on entry:
     *errptr == NULL
     *errptr points to a malloc()ed null-terminated error message
       (On Windows, *errptr must have been malloc()-ed by this library.)
  On success, a leveldb routine leaves *errptr unchanged.
  On failure, leveldb frees the old value of *errptr and
  set *errptr to a malloc()ed error message.

  (4) Bools have the type uint8_t (0 == false; rest == true)

  (5) All of the pointer arguments must be non-NULL.
*/

import Darwin.C.stdarg
import Darwin.C.stddef
import Darwin.C.stdint

/* DB operations */
@_silgen_name("leveldb_open")
func leveldb_open(_ options: OpaquePointer, _ name: UnsafePointer<Int8>, _ errptr: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>) -> OpaquePointer?

@_silgen_name("leveldb_close")
func leveldb_close(_ db: OpaquePointer)

@_silgen_name("leveldb_put")
func leveldb_put(_ db: OpaquePointer, _ options: OpaquePointer, _ key: UnsafePointer<Int8>, _ keylen: Int, _ val: UnsafePointer<Int8>, _ vallen: Int, _ errptr: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>)

@_silgen_name("leveldb_delete")
func leveldb_delete(_ db: OpaquePointer, _ options: OpaquePointer, _ key: UnsafePointer<Int8>, _ keylen: Int, _ errptr: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>)

@_silgen_name("leveldb_write")
func leveldb_write(_ db: OpaquePointer, _ options: OpaquePointer, _ batch: OpaquePointer, _ errptr: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>)

/* Returns NULL if not found.  A malloc()ed array otherwise.
   Stores the length of the array in *vallen. */
@_silgen_name("leveldb_get")
func leveldb_get(_ db: OpaquePointer, _ options: OpaquePointer, _ key: UnsafePointer<Int8>, _ keylen: Int, _ vallen: UnsafeMutablePointer<Int>!, _ errptr: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>!) -> UnsafeMutablePointer<Int8>?

@_silgen_name("leveldb_create_iterator")
func leveldb_create_iterator(_ db: OpaquePointer, _ options: OpaquePointer) -> OpaquePointer

@_silgen_name("leveldb_create_snapshot")
func leveldb_create_snapshot(_ db: OpaquePointer) -> OpaquePointer

@_silgen_name("leveldb_release_snapshot")
func leveldb_release_snapshot(_ db: OpaquePointer, _ snapshot: OpaquePointer)

/* Returns NULL if property name is unknown.
   Else returns a pointer to a malloc()-ed null-terminated value. */
@_silgen_name("leveldb_property_value")
func leveldb_property_value(_ db: OpaquePointer, _ propname: UnsafePointer<Int8>) -> UnsafeMutablePointer<Int8>?

@_silgen_name("leveldb_approximate_sizes")
func leveldb_approximate_sizes(_ db: OpaquePointer, _ num_ranges: Int32, _ range_start_key: UnsafePointer<UnsafePointer<Int8>?>?, _ range_start_key_len: UnsafePointer<Int>, _ range_limit_key: UnsafePointer<UnsafePointer<Int8>?>?, _ range_limit_key_len: UnsafePointer<Int>, _ sizes: UnsafeMutablePointer<UInt64>)

@_silgen_name("leveldb_compact_range")
func leveldb_compact_range(_ db: OpaquePointer, _ start_key: UnsafePointer<Int8>!, _ start_key_len: Int, _ limit_key: UnsafePointer<Int8>!, _ limit_key_len: Int)

/* Management operations */
@_silgen_name("leveldb_destroy_db")
func leveldb_destroy_db(_ options: OpaquePointer, _ name: UnsafePointer<Int8>, _ errptr: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>)

@_silgen_name("leveldb_repair_db")
func leveldb_repair_db(_ options: OpaquePointer, _ name: UnsafePointer<Int8>, _ errptr: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>)

/* Iterator */

@_silgen_name("leveldb_iter_destroy")
func leveldb_iter_destroy(_: OpaquePointer)

@_silgen_name("leveldb_iter_valid")
func leveldb_iter_valid(_: OpaquePointer) -> UInt8

@_silgen_name("leveldb_iter_seek_to_first")
func leveldb_iter_seek_to_first(_: OpaquePointer)

@_silgen_name("leveldb_iter_seek_to_last")
func leveldb_iter_seek_to_last(_: OpaquePointer)

@_silgen_name("leveldb_iter_seek")
func leveldb_iter_seek(_: OpaquePointer, _ k: UnsafePointer<Int8>!, _ klen: Int)

@_silgen_name("leveldb_iter_next")
func leveldb_iter_next(_: OpaquePointer)

@_silgen_name("leveldb_iter_prev")
func leveldb_iter_prev(_: OpaquePointer)

@_silgen_name("leveldb_iter_key")
func leveldb_iter_key(_: OpaquePointer, _ klen: UnsafeMutablePointer<Int>?) -> UnsafePointer<Int8>?

@_silgen_name("leveldb_iter_value")
func leveldb_iter_value(_: OpaquePointer, _ vlen: UnsafeMutablePointer<Int>?) -> UnsafePointer<Int8>?

@_silgen_name("leveldb_iter_get_error")
func leveldb_iter_get_error(_: OpaquePointer, _ errptr: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>)

/* Write batch */

@_silgen_name("leveldb_writebatch_create")
func leveldb_writebatch_create() -> OpaquePointer

@_silgen_name("leveldb_writebatch_destroy")
func leveldb_writebatch_destroy(_: OpaquePointer)

@_silgen_name("leveldb_writebatch_clear")
func leveldb_writebatch_clear(_: OpaquePointer)

@_silgen_name("leveldb_writebatch_put")
func leveldb_writebatch_put(_: OpaquePointer, _ key: UnsafePointer<Int8>, _ klen: Int, _ val: UnsafePointer<Int8>, _ vlen: Int)

@_silgen_name("leveldb_writebatch_delete")
func leveldb_writebatch_delete(_: OpaquePointer, _ key: UnsafePointer<Int8>, _ klen: Int)

@_silgen_name("leveldb_writebatch_iterate")
func leveldb_writebatch_iterate(_: OpaquePointer, _ state: UnsafeMutableRawPointer!, _ put: (@convention(c) (UnsafeMutableRawPointer?, UnsafePointer<Int8>?, Int, UnsafePointer<Int8>?, Int) -> Void)!, _ deleted: (@convention(c) (UnsafeMutableRawPointer?, UnsafePointer<Int8>?, Int) -> Void)!)

@_silgen_name("leveldb_writebatch_append")
func leveldb_writebatch_append(_ destination: OpaquePointer, _ source: OpaquePointer)

/* Options */
@_silgen_name("leveldb_options_create")
func leveldb_options_create() -> OpaquePointer

@_silgen_name("leveldb_options_destroy")
func leveldb_options_destroy(_: OpaquePointer)

@_silgen_name("leveldb_options_set_comparator")
func leveldb_options_set_comparator(_: OpaquePointer, _: OpaquePointer)

@_silgen_name("leveldb_options_set_filter_policy")
func leveldb_options_set_filter_policy(_: OpaquePointer, _: OpaquePointer)

@_silgen_name("leveldb_options_set_create_if_missing")
func leveldb_options_set_create_if_missing(_: OpaquePointer, _: UInt8)

@_silgen_name("leveldb_options_set_error_if_exists")
func leveldb_options_set_error_if_exists(_: OpaquePointer, _: UInt8)

@_silgen_name("leveldb_options_set_paranoid_checks")
func leveldb_options_set_paranoid_checks(_: OpaquePointer, _: UInt8)

@_silgen_name("leveldb_options_set_env")
func leveldb_options_set_env(_: OpaquePointer, _: OpaquePointer)

@_silgen_name("leveldb_options_set_info_log")
func leveldb_options_set_info_log(_: OpaquePointer, _: OpaquePointer)

@_silgen_name("leveldb_options_set_write_buffer_size")
func leveldb_options_set_write_buffer_size(_: OpaquePointer, _: Int)

@_silgen_name("leveldb_options_set_max_open_files")
func leveldb_options_set_max_open_files(_: OpaquePointer, _: Int32)

@_silgen_name("leveldb_options_set_cache")
func leveldb_options_set_cache(_: OpaquePointer, _: OpaquePointer)

@_silgen_name("leveldb_options_set_block_size")
func leveldb_options_set_block_size(_: OpaquePointer, _: Int)

@_silgen_name("leveldb_options_set_block_restart_interval")
func leveldb_options_set_block_restart_interval(_: OpaquePointer, _: Int32)

@_silgen_name("leveldb_options_set_max_file_size")
func leveldb_options_set_max_file_size(_: OpaquePointer, _: Int)

@_silgen_name("leveldb_options_set_compression")
func leveldb_options_set_compression(_: OpaquePointer, _: Int32)

/* Comparator */
@_silgen_name("leveldb_comparator_create")
func leveldb_comparator_create(_ state: UnsafeMutableRawPointer!, _ destructor: (@convention(c) (UnsafeMutableRawPointer?) -> Void)!, _ compare: (@convention(c) (UnsafeMutableRawPointer?, UnsafePointer<Int8>?, Int, UnsafePointer<Int8>?, Int) -> Int32)!, _ name: (@convention(c) (UnsafeMutableRawPointer?) -> UnsafePointer<Int8>?)!) -> OpaquePointer!

@_silgen_name("leveldb_comparator_destroy")
func leveldb_comparator_destroy(_: OpaquePointer)

/* Filter policy */
@_silgen_name("leveldb_filterpolicy_create")
func leveldb_filterpolicy_create(_ state: UnsafeMutableRawPointer, _ destructor: (@convention(c) (UnsafeMutableRawPointer?) -> Void), _ create_filter: (@convention(c) (UnsafeMutableRawPointer?, UnsafePointer<UnsafePointer<Int8>?>?, UnsafePointer<Int>?, Int32, UnsafeMutablePointer<Int>?) -> UnsafeMutablePointer<Int8>?), _ key_may_match: (@convention(c) (UnsafeMutableRawPointer?, UnsafePointer<Int8>?, Int, UnsafePointer<Int8>?, Int) -> UInt8)!, _ name: (@convention(c) (UnsafeMutableRawPointer?) -> UnsafePointer<Int8>?)!) -> OpaquePointer!

@_silgen_name("leveldb_filterpolicy_destroy")
func leveldb_filterpolicy_destroy(_: OpaquePointer)

@_silgen_name("leveldb_filterpolicy_create_bloom")
func leveldb_filterpolicy_create_bloom(_ bits_per_key: Int32) -> OpaquePointer

/* Read options */
@_silgen_name("leveldb_readoptions_create")
func leveldb_readoptions_create() -> OpaquePointer

@_silgen_name("leveldb_readoptions_destroy")
func leveldb_readoptions_destroy(_: OpaquePointer)

@_silgen_name("leveldb_readoptions_set_verify_checksums")
func leveldb_readoptions_set_verify_checksums(_: OpaquePointer, _: UInt8)

@_silgen_name("leveldb_readoptions_set_fill_cache")
func leveldb_readoptions_set_fill_cache(_: OpaquePointer, _: UInt8)

@_silgen_name("leveldb_readoptions_set_snapshot")
func leveldb_readoptions_set_snapshot(_: OpaquePointer, _: OpaquePointer?)

/* Write options */

@_silgen_name("leveldb_writeoptions_create")
func leveldb_writeoptions_create() -> OpaquePointer

@_silgen_name("leveldb_writeoptions_destroy")
func leveldb_writeoptions_destroy(_: OpaquePointer)

@_silgen_name("leveldb_writeoptions_set_sync")
func leveldb_writeoptions_set_sync(_: OpaquePointer, _: UInt8)

/* Cache */
@_silgen_name("leveldb_cache_create_lru")
func leveldb_cache_create_lru(_ capacity: Int) -> OpaquePointer

@_silgen_name("leveldb_cache_destroy")
func leveldb_cache_destroy(_ cache: OpaquePointer)

/* Env */
@_silgen_name("leveldb_create_default_env")
func leveldb_create_default_env() -> OpaquePointer

@_silgen_name("leveldb_env_destroy")
func leveldb_env_destroy(_: OpaquePointer)

/* If not NULL, the returned buffer must be released using leveldb_free(). */
@_silgen_name("leveldb_env_get_test_directory")
func leveldb_env_get_test_directory(_: OpaquePointer) -> UnsafeMutablePointer<Int8>

/* Utility */

/* Calls free(ptr).
   REQUIRES: ptr was malloc()-ed and returned by one of the routines
   in this file.  Note that in certain cases (typically on Windows), you
   may need to call this routine instead of free(ptr) to dispose of
   malloc()-ed memory returned by this library. */
@_silgen_name("leveldb_free")
func leveldb_free(_ ptr: UnsafeMutableRawPointer)

/* Return the major version number for this release. */
@_silgen_name("leveldb_major_version")
func leveldb_major_version() -> Int32

/* Return the minor version number for this release. */
@_silgen_name("leveldb_minor_version")
func leveldb_minor_version() -> Int32

