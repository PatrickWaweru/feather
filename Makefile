# Copyright (c) 2014-2021, The Monero Project
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of
#    conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list
#    of conditions and the following disclaimer in the documentation and/or other
#    materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors may be
#    used to endorse or promote products derived from this software without specific
#    prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
# THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
# THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY

CMAKEFLAGS = \
	-DARCH=x86_64 \
	-DBUILD_64=On \
	-DBUILD_TESTS=Off \
	-DXMRTO=ON \
	-DCMAKE_CXX_STANDARD=11 \
	-DCMAKE_VERBOSE_MAKEFILE=On \
	-DINSTALL_VENDORED_LIBUNBOUND=Off \
	-DMANUAL_SUBMODULES=1 \
	-DSTATIC=On \
	-DUSE_DEVICE_TREZOR=Off \
	$(CMAKEFLAGS_EXTRA)

release-static: CMAKEFLAGS += -DBUILD_TAG="linux-x64"
release-static: CMAKEFLAGS += -DBUILD_TOR=On
release-static: CMAKEFLAGS += -DCMAKE_BUILD_TYPE=Release
release-static:
	cmake -Bbuild $(CMAKEFLAGS)
	$(MAKE) -Cbuild

windows-mxe-release: CMAKEFLAGS += -DBUILD_TAG="win-x64"
windows-mxe-release: CMAKEFLAGS += -DBUILD_TOR=On
windows-mxe-release: CMAKEFLAGS += -DCMAKE_BUILD_TYPE=Release
windows-mxe-release:
	cmake -Bbuild $(CMAKEFLAGS)
	$(MAKE) -Cbuild

windows-mxe-debug: CMAKEFLAGS += -DBUILD_TAG="win-x64"
windows-mxe-debug: CMAKEFLAGS += -DBUILD_TOR=Off
windows-mxe-debug: CMAKEFLAGS += -DCMAKE_BUILD_TYPE=Debug
windows-mxe-debug:
	cmake -Bbuild $(CMAKEFLAGS)
	$(MAKE) -Cbuild

mac-release: CMAKEFLAGS += -DSTATIC=Off
mac-release: CMAKEFLAGS += -DBUILD_TAG="mac-x64"
mac-release: CMAKEFLAGS += -DBUILD_TOR=Off
mac-release: CMAKEFLAGS += -DCMAKE_BUILD_TYPE=Release
mac-release:
	cmake -Bbuild $(CMAKEFLAGS)
	$(MAKE) -Cbuild
	$(MAKE) -Cbuild deploy