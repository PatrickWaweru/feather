package=tor_linux
$(package)_version=0.4.8.4
$(package)_download_path=https://dist.torproject.org/
$(package)_file_name=tor-$($(package)_version).tar.gz
$(package)_sha256_hash=09c1ce74a25fc3b48c81ff146cbd0dd538cbbb8fe4e2964fc2fb2b192f6a1d2b
$(package)_dependencies=libevent openssl zlib

define $(package)_set_vars
    $(package)_config_opts=--disable-asciidoc --disable-manpage --disable-html-manual --disable-system-torrc
    $(package)_config_opts+=--disable-module-relay --disable-lzma --disable-zstd --enable-static-tor
    $(package)_config_opts+=--with-libevent-dir=$(host_prefix) --with-openssl-dir=$(host_prefix)
    $(package)_config_opts+=--with-zlib-dir=$(host_prefix) --disable-tool-name-check --enable-fatal-warnings
    $(package)_config_opts+=--prefix=$(host_prefix)
    $(package)_cflags+=-O2
    $(package)_cxxflags+=-O2
endef

define $(package)_config_cmds
    $($(package)_autoconf) $($(package)_config_opts)
endef

define $(package)_build_cmds
    $(MAKE)
endef

define $(package)_stage_cmds
    $(MAKE) DESTDIR=$($(package)_staging_dir) install
endef

define $(package)_postprocess_cmds
    $(host_toolchain)strip -s -D bin/tor && \
    mkdir $($(package)_staging_prefix_dir)/Tor/ && \
    cp bin/tor $($(package)_staging_prefix_dir)/Tor
endef
