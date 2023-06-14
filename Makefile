CXXFLAGS=-Wall -fPIC -std=c++11

LDLIBS=-lpam -lcurl

objects = src/pam_social.o \
		  src/include/config.o \

all: pam_social.so

build_rpm: 
	rpmbuild ./

build_deb:
	debbuild ./

install_with_tester: install
    # Change PAM modules for pamtester so we can run pamtest
	echo "TODO"

install_rocky: pam_social.so
	install -D -t $(DESTDIR)$(PREFIX)/lib64/security pam_social.so
	install -m 600 -D config_template.json $(DESTDIR)$(PREFIX)/etc/pam_social/config.json

%.o: %.c %.h
	$(CXX) $(CXXFLAGS) -c $< -o $@

pam_social.so: $(objects)
	$(CXX) -shared $^ $(LDLIBS) -o $@

clean:
	rm -f $(objects)

distclean: clean
	rm -f pam_social.so

install: pam_social.so
	install -D -t $(DESTDIR)$(PREFIX)/lib/security pam_social.so
	install -m 600 -D config_template.json $(DESTDIR)$(PREFIX)/etc/pam_social/config.json