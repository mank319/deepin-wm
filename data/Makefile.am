SUBDIRS = \
	icons \
	$(NULL)

stylesdir = $(pkgdatadir)
styles_DATA = deepin-wm.css gala.css texture.png close.png

applicationsdir = $(datadir)/applications
applications_DATA = gala.desktop gala-wayland.desktop gala-multitaskingview.desktop

@INTLTOOL_DESKTOP_RULE@

gsettings_SCHEMAS = org.pantheon.desktop.gala.gschema.xml

@INTLTOOL_XML_NOMERGE_RULE@

@GSETTINGS_RULES@

gschemas.compiled: Makefile $(gsettings_SCHEMAS:.xml=.valid)
	$(AM_V_GEN) $(GLIB_COMPILE_SCHEMAS) --targetdir=$(builddir) $(builddir)

all-local: gschemas.compiled

EXTRA_DIST = \
	deepin-test.desktop \
	deepin-wm.css \
	gala.css \
	gala.desktop \
	gala-wayland.desktop \
	gala-multitaskingview.desktop.in \
	texture.png \
	close.png \
	org.pantheon.desktop.gala.gschema.xml.in.in \
	$(NULL)

CLEANFILES = \
	gala-multitaskingview.desktop \
	gschemas.compiled \
	org.pantheon.desktop.gala.gschema.xml \
	org.pantheon.desktop.gala.gschema.xml.in \
	$(NULL)

# rename data file with prefix 'deepin'
install-data-hook:
	mv $(DESTDIR)$(applicationsdir)/gala.desktop $(DESTDIR)$(applicationsdir)/deepin-wm.desktop
	mv $(DESTDIR)$(applicationsdir)/gala-multitaskingview.desktop $(DESTDIR)$(applicationsdir)/deepin-wm-multitaskingview.desktop
	mv $(DESTDIR)$(gsettingsschemadir)/org.pantheon.desktop.gala.gschema.xml $(DESTDIR)$(gsettingsschemadir)/com.deepin.wrap.pantheon.desktop.gala.gschema.xml
