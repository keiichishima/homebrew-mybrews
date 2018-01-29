class Libeemd < Formula
  desc "C library for performing the ensemble empirical mode decomposition"
  homepage "https://bitbucket.org/luukko/libeemd"
  url "https://bitbucket.org/luukko/libeemd/get/v1.4.tar.gz"
  sha256 "c484f4287f4469f3ac100cf4ecead8fd24bf43854efa63650934dd698d6b298b"
  depends_on "gsl" => :run
  depends_on "pkg-config" => :run
  def install
    args = %W[
      PREFIX=#{prefix}
    ]
    system "make", *args
    system "make", "install", *args
  end
  patch :p0, :DATA
  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test libeemd`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

__END__
--- Makefile.orig	2016-09-19 16:58:13.000000000 +0900
+++ Makefile	2018-01-29 13:05:21.000000000 +0900
@@ -23,7 +23,7 @@
 endef
 export uninstall_msg
 
-all: libeemd.so.$(version) libeemd.a eemd.h
+all: libeemd.$(version).dylib libeemd.a eemd.h
 
 clean:
 	rm -f libeemd.so libeemd.so.$(version) libeemd.a eemd.h obj/eemd.o
@@ -34,8 +34,8 @@
 	install -d $(PREFIX)/lib
 	install -m644 eemd.h $(PREFIX)/include
 	install -m644 libeemd.a $(PREFIX)/lib
-	install libeemd.so.$(version) $(PREFIX)/lib
-	cp -Pf libeemd.so $(PREFIX)/lib
+	install libeemd.$(version).dylib $(PREFIX)/lib
+	cp -Pf libeemd.dylib $(PREFIX)/lib
 
 uninstall:
 	@echo "$$uninstall_msg"
@@ -49,9 +49,9 @@
 libeemd.a: obj/eemd.o
 	$(AR) rcs $@ $^
 
-libeemd.so.$(version): src/eemd.c src/eemd.h
+libeemd.$(version).dylib: src/eemd.c src/eemd.h
 	gcc $(commonflags) $< -fPIC -shared -Wl,$(SONAME),$@ $(gsl_flags) -o $@
-	ln -sf $@ libeemd.so
+	ln -sf $@ libeemd.dylib
 
 eemd.h: src/eemd.h
 	cp $< $@

