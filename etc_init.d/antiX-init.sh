#!/bin/bash
### BEGIN INIT INFO
# Provides:          antiX-init
# Required-Start:    checkroot
# Required-Stop:     
# Should-Start:	     
# Should-Stop:       
# Default-Start:     
# Default-Stop:      
# Short-Description: antiX-init
# Description:       Initial init for antiX live
### END INIT INFO

PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin"
export PATH

umask 022

# Ignore these signals: INT, TERM, SEGV
trap "" 2 3 11

. /lib/lsb/init-functions

# Read in boot parameters
CMDLINE="$(cat /proc/cmdline)"

getbootparam(){
case "$CMDLINE" in *$1=*) ;; *) return 1; ;; esac
result="${CMDLINE##*$1=}"
result="${result%%[     ]*}"
echo "$result"
return 0
}

isbootparam(){
case "$CMDLINE" in *$1*) return 0;; esac
return 1
}

# Determine if running from HD
INSTALLED="yes"
if [ -e /proc/sys/kernel/real-root-dev ]; then
case "$(cat /proc/sys/kernel/real-root-dev 2>/dev/null)" in 256|0x100) INSTALLED="" ; ;;
esac
fi

###
# some keyboard defaults
###
XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT=""
XKBOPTIONS="grp:alt_shift_toggle,terminate:ctrl_alt_bksp,grp_led:scroll"

# No kernel messages while probing modules
echo "0" > /proc/sys/kernel/printk

EMPTY_LOGS="yes"
EMPTY_CACHE="yes"
if [ -f /etc/default/antiX ] ; then
    # antiX startup option file (needs work)
  if [ "$INSTALLED" = "yes" ]; then
    sed -i 's/^INSTALLER=.*/INSTALLER=no/g' /etc/default/antiX
  fi
  . /etc/default/antiX
fi

if [ "$EMPTY_LOGS" = "yes" -a "$INSTALLED" = "yes" ]; then
  rm -f /var/log/* >/dev/null 2>&1
  echo "Empty log files... done."
fi    

if [ "$EMPTY_CACHE" = "yes" -a "$INSTALLED" = "yes" ]; then
  /usr/bin/apt-get clean >/dev/null 2>&1
  echo "Empty apt cache... done."
fi

# make sure live-user is owner of their /home
if [ -z "$INSTALLED" ]; then
 cp -r /linux/root/.[a-z]* /root 2>/dev/null
 cp -r /linux/root/* /root 2>/dev/null

 LANGUAGE="$(getbootparam lang 2>/dev/null)"
 [ -n "$LANGUAGE" ] || LANGUAGE="en"


case "$LANGUAGE" in
	de|de_DE)
		## German
		#LANGUAGE="de_DE:de"
		LANG="de_DE.UTF-8"
		KEYTABLE="de-latin1-nodeadkeys"
		XKBLAYOUT="de,us"
		TZ="Europe/Berlin"
                FLUX="de"
		COUNTRY="German"
                MIRROR="ftp.de.debian.org"
		;;
        ar|ar_SA)
		## Arabic
		#LANGUAGE="ar_SA:ar"
		LANG="ar_SA.UTF-8"
		KEYTABLE="ar"
                XKBLAYOUT="ar,us"
		TZ="Saudi Arabia/Riyadh"
                FLUX="ar"
		COUNTRY="Arabic"
                MIRROR="ftp.us.debian.org"
		;;
	au|en_AU)
		## Australian
		#LANGUAGE="en_AU:en"
		LANG="en_AU.UTF-8"
		KEYTABLE="us"
		XKBLAYOUT="us"
		TZ="Australia/Sydney"
                FLUX="en"
		COUNTRY="AUS-English"
                MIRROR="ftp.au.debian.org"
		;;
	be-fr|fr_BE)
		## Belgian-French
		#LANGUAGE="fr_BE:be-fr"
		LANG="fr_BE.UTF-8"
		KEYTABLE="be2-latin1"
		XKBLAYOUT="be,fr,us"
		TZ="Europe/Brussels"
                FLUX="fr"
		COUNTRY="Belgian-French"
                MIRROR="ftp.be.debian.org"
		;;
        be-nl|nl_BE)
		## Belgian-Dutch
		#LANGUAGE="nl_BE:be-nl"
		LANG="nl_BE.UTF-8"
		KEYTABLE="be2-latin1"
		XKBLAYOUT="be,fr,us"
		TZ="Europe/Brussels"
                FLUX="nl"
		COUNTRY="Belgian-Dutch"
                MIRROR="ftp.be.debian.org"
		;;
        by|be_BY)
		## Belarus
		#LANGUAGE="be_BY:by"
		LANG="be_BY.UTF-8"
		KEYTABLE="by"
		XKBLAYOUT="by,us"
		TZ="Europe/Minsk"
                FLUX="en"
		COUNTRY="Belarus"
                MIRROR="ftp.ru.debian.org"
		;;
	bg|bg_BG)
		## Bulgarian
		#LANGUAGE="bg_BG:bg"
		LANG="bg_BG.UTF-8"
		KEYTABLE="bg"
		XKBLAYOUT="bg,us"
		TZ="Europe/Sofia"
                FLUX="bg"
		COUNTRY="Bulgarian"
                MIRROR="ftp.bg.debian.org"
		;;
	br|pt_BR)
		## Brazilian
		#LANGUAGE="pt_BR:pt"
		LANG="pt_BR.UTF-8"
		KEYTABLE="br-abnt2"
		XKBLAYOUT="br,us"
		TZ="America/Sao_Paulo"
                FLUX="pt-br"
		COUNTRY="Brazilian"
                MIRROR="ftp.br.debian.org"
		;;
        ca|ca_ES)
		## Catalan
		#LANGUAGE="ca_ES:es"
		LANG="ca_ES.UTF-8"
		KEYTABLE="es"
                XKBLAYOUT="es,us"
		TZ="Europe/Madrid"
                FLUX="ca"
		COUNTRY="Catalan"
                MIRROR="ftp.es.debian.org"
		;;
	ch|de_CH)
		## Swiss
		#LANGUAGE="de_CH:de"
		LANG="de_CH.UTF-8"
		KEYTABLE="sg-latin1"
		XKBLAYOUT="ch,de,fr,us"
		TZ="Europe/Zurich"
                FLUX="de"
		COUNTRY="Swiss-German"
                MIRROR="ftp.ch.debian.org"
		;;
	cn|zh_CN)
		## Chinese
                #LANGUAGE="zh_CN:cn"
		LANG="zh_CN.UTF-8"
		KEYTABLE="us"
		XKBLAYOUT="us"
		TZ="Asia/Shanghai"
                FLUX="cn"
		COUNTRY="Chinese"
                MIRROR="ftp.hk.debian.org"
		;;
	cs|cz|cs_CZ)
		## Czech
		#LANGUAGE="cs_CZ:cs"
		LANG="cs_CZ.UTF-8"
		KEYTABLE="cz-lat2"
		XKBLAYOUT="cz,us"
		TZ="Europe/Prague"
                FLUX="cs"
		COUNTRY="Czech"
                MIRROR="ftp.cz.debian.org"
		;;
	dk|da|da_DK)
		## Danish
                #LANGUAGE="da_DK:dk"
		LANG="da_DK.UTF-8"
		KEYTABLE="dk"
		XKBLAYOUT="dk,us"
		TZ="Europe/Copenhagen"
                FLUX="da"
		COUNTRY="Danish"
                MIRROR="ftp.dk.debian.org"
		;;
	el|gr|el_GR)
		## Greek
		#LANGUAGE="el_GR:el"
		LANG="el_GR.UTF-8"
		KEYTABLE="gr"
		XKBLAYOUT="gr,us"
		TZ="Europe/Athens"
                FLUX="el"
		COUNTRY="Greek"
                MIRROR="ftp.gr.debian.org"
		;;
	es|es_ES)
		## Spanish
		#LANGUAGE="es_ES:es"
		LANG="es_ES.UTF-8"
		KEYTABLE="es"
		XKBLAYOUT="es,us"
		TZ="Europe/Madrid"
                FLUX="es"
		COUNTRY="Spanish"
                MIRROR="ftp.es.debian.org"
		;;
        et|et_EE)
		## Estonian
		#LANGUAGE="et_EE:et"
		LANG="et_EE.UTF-8"
		KEYTABLE="et-nodeadkeys"
                XKBLAYOUT="et,us"
		TZ="Europe/Tallinn"
                FLUX="et"
		COUNTRY="Estonian"
                MIRROR="ftp.ee.debian.org"
		;;
        eu|eu_ES)
		## Basque
		#LANGUAGE="eu_ES:eu"
		LANG="eu_ES.UTF-8"
		KEYTABLE="es"
		XKBLAYOUT="es,us"
		TZ="Europe/Madrid"
                FLUX="eu"
		COUNTRY="Basque"
                MIRROR="ftp.es.debian.org"
		;;
        fa|fa_IR)
		## Farsi-Iranian
		#LANGUAGE="fa_IR:fa"
		LANG="fa_IR.UTF-8"
		KEYTABLE="fa"
                XKBLAYOUT="ir,us"
		TZ="Asia/Tehran"
                FLUX="fa"
		COUNTRY="Iranian"
                MIRROR="ftp.de.debian.org"
		;;
	fi|fi_FI)
		## Finnish
		#LANGUAGE="fi_FI:fi"
		LANG="fi_FI.UTF-8"
		KEYTABLE="fi-latin1"
		XKBLAYOUT="fi,us"
		TZ="Europe/Helsinki"
                FLUX="fi"
		COUNTRY="Finnish"
                MIRROR="ftp.fi.debian.org"
		;;
	fr|fr_FR)
		## French
		#LANGUAGE="fr_FR:fr"
		LANG="fr_FR.UTF-8"
		KEYTABLE="fr"
		XKBLAYOUT="fr,us"
		TZ="Europe/Paris"
                FLUX="fr"
		COUNTRY="French"
                MIRROR="ftp.fr.debian.org"
		;;
	ga|ga_IE)
		## Gaelic
                #LANGUAGE="ga_IE:ga"
		LANG="ga_IE.UTF-8"
		KEYTABLE="uk"
		XKBLAYOUT="ie,us"
		TZ="Europe/Dublin"
                FLUX="en"
		COUNTRY="Gaelic"
                MIRROR="ftp.ie.debian.org"
		;;
        ge|ka_GE)
		## Georgian
                #LANGUAGE="ka_GE:ge"
		LANG="ka_GE.UTF-8"
		KEYTABLE="ge"
		XKBLAYOUT="ge,us"
		TZ="Asia/Tbilisi"
                FLUX="en"
		COUNTRY="Georgian"
                MIRROR="ftp.ru.debian.org"
		;;
	he|il|he_IL)
		## Hebrew
		#LANGUAGE="he_IL:he"
		LANG="he_IL.UTF-8"
		KEYTABLE="us"
		XKBLAYOUT="il,us"
		TZ="Asia/Jerusalem"
                FLUX="en"
		COUNTRY="Hebrew"
                MIRROR="ftp.us.debian.org"
		;;
	hr|hr_HR)
		## Croatian
		#LANGUAGE=hr_HR:hr" 
		LANG="hr_HR.UTF-8" 
		KEYTABLE="hr" 
		XKBLAYOUT="hr,us" 
		TZ="Europe/Zagreb" 
                FLUX="hr"
		COUNTRY="Croatian"
                MIRROR="ftp.hr.debian.org"
		;;
        hu|hu_HU)
		## Hungarian
		#LANGUAGE="hu_HU:hu"
		LANG="hu_HU.UTF-8"
		KEYTABLE="hu"
                XKBLAYOUT="hu,us"
		TZ="Europe/Budapest"
                FLUX="hu"
		COUNTRY="Hungarian"
                MIRROR="ftp.hu.debian.org"
		;;
        hy|am|hy_AM)
		## Armenian
		#LANGUAGE="hy_AM:am"
		LANG="hy_AM.UTF-8"
		KEYTABLE="am"
                XKBLAYOUT="am,us"
                FLUX="am"
                COUNTRY="Armenian"
                MIRROR="ftp.ru.debian.org" #nearest?
		;;
	ie|en_IE)
		## Irish-English
		#LANGUAGE="en_IE:en"
		LANG="en_IE.UTF-8"
		KEYTABLE="uk"
		XKBLAYOUT="ie,gb,us"
		TZ="Europe/Dublin"
                FLUX="en"
		COUNTRY="Irish"
                MIRROR="ftp.ie.debian.org"
		;;
        is|is_IS)
		## Icelandic
		#LANGUAGE="is_IS:is"
		LANG="is_IS.UTF-8"
		KEYTABLE="is-latin1"
		XKBLAYOUT="is,us"
		TZ="Europe/Reykjavík"
                FLUX="is"
		COUNTRY="Icelandic"
                MIRROR="ftp.is.debian.org"
		;;
	it|it_IT)
		## Italian
		#LANGUAGE="it_IT:it"
		LANG="it_IT.UTF-8"
		KEYTABLE="it"
		XKBLAYOUT="it,us"
		TZ="Europe/Rome"
                FLUX="it"
		COUNTRY="Italian"
                MIRROR="ftp.it.debian.org"
		;;
	ja|ja_JP)
		## Japanese
		#LANGUAGE="ja_JP:ja"
		LANG="ja_JP.UTF-8"
		KEYTABLE="us"
		XKBLAYOUT="jp,us"
		TZ="Asia/Tokyo"
                FLUX="ja"
		COUNTRY="Japanese"
                MIRROR="ftp.jp.debian.org"
		;;
        ko|ko_KR)
		## Korean
		#LANGUAGE="ko_KR:ko"
		LANG="ko_KR.UTF-8"
		KEYTABLE="us"
		XKBLAYOUT="kr,us"
		TZ="Asia/Seoul"
                FLUX="ko"
		COUNTRY="Korean"
                MIRROR="ftp.kr.debian.org"
		;; 
        lt|lt_LT)
		## Lithuanian
		#LANGUAGE="lt_LT:lt"
		LANG="lt_LT.UTF-8"
		KEYTABLE="lt"
                XKBLAYOUT="lt,us"
		TZ="Europe/Vilnius"
                FLUX="lt"
		COUNTRY="Lithuanian"
                MIRROR="ftp.ee.debian.org"
                ;;
        lv|lv_LV)
		## Latvian
		#LANGUAGE="lv_LV:lv"
		LANG="lv_LV.UTF-8"
		KEYTABLE="lv-latin7"
                XKBLAYOUT="lv,us"
		TZ="Europe/Riga"
                FLUX="lv"
		COUNTRY="Latvian"
                MIRROR="ftp.ee.debian.org"
                ;;
        mk|mk_MK)
		## Macedonian
		#LANGUAGE="mk_MK:mk"
		LANG="mk_MK.UTF-8"
		KEYTABLE="mk"
                XKBLAYOUT="mk,us"
		TZ="Europe/Skopje"
                FLUX="mk"
		COUNTRY="Macedonian"
                MIRROR="ftp.gr.debian.org" #nearest?
		;;
        no|nb_NO)
		## Norwegian
		#LANGUAGE="nb_NO:no"
		LANG="nb_NO.UTF-8"
		KEYTABLE="no-latin1"
                XKBLAYOUT="no,us"
		TZ="Europe/Oslo"
                FLUX="no"
		COUNTRY="Norwegian"
                MIRROR="ftp.no.debian.org"
		;;
	nl|nl_NL)
		## Dutch
		#LANGUAGE="nl_NL:nl"
		LANG="nl_NL.UTF-8"
		KEYTABLE="us"
		XKBLAYOUT="nl,us"
		TZ="Europe/Amsterdam"
                FLUX="nl"
		COUNTRY="Dutch"
                MIRROR="ftp.nl.debian.org"
		;;
        nz|en_NZ)
		## New Zealand
		#LANGUAGE="en_NZ:en"
		LANG="en_NZ.UTF-8"
		KEYTABLE="us"
		XKBLAYOUT="us"
		TZ="Pacific/Auckland"
                FLUX="en"
		COUNTRY="NZ-English"
                MIRROR="ftp.nz.debian.org"
		;;
	pl|pl_PL)
		## Polish
		#LANGUAGE="pl_PL:pl"
		LANG="pl_PL.UTF-8"
		KEYTABLE="pl"
		XKBLAYOUT="pl,us"
		TZ="Europe/Warsaw"
                FLUX="pl"
		COUNTRY="Polish"
                MIRROR="ftp.pl.debian.org"
		;;
	pt|pt_PT)
		## Portuguese
		#LANGUAGE="pt_PT:pt"
		LANG="pt_PT.UTF-8"
		KEYTABLE="pt-latin1"
		XKBLAYOUT="pt,us"
		TZ="Europe/Lisbon"
                FLUX="pt"
		COUNTRY="Portugese"
                MIRROR="ftp.pt.debian.org"
		;;
        ro|ro_RO)
		## Romanian
		#LANGUAGE="ro_RO:ro"
		LANG="ro_RO.UTF-8"
		KEYTABLE="ro"
                XKBLAYOUT="ro,us"
		TZ="Europe/Bucharest"
                FLUX="ro"
		COUNTRY="Romanian"
                MIRROR="ftp.ro.debian.org"
		;;
	ru|ru_RU)
		## Russian
		#LANGUAGE="ru_RU:ru"
		LANG="ru_RU.UTF-8"
		KEYTABLE="ru"
		XKBLAYOUT="ru,us"
		TZ="Europe/Moscow"
                FLUX="ru"
		COUNTRY="Russian"
                MIRROR="ftp.ru.debian.org"
		;;
	sk|sk_SK)
		## Slovak
		#LANGUAGE="sk_SK:sk"
		LANG="sk_SK.UTF-8"
		KEYTABLE="sk-qwerty"
		XKBLAYOUT="sk,us"
		TZ="Europe/Bratislava"
                FLUX="sk"
		COUNTRY="Slovak"
                MIRROR="ftp.sk.debian.org"
		;;
	sl|sl_SI)
		## Slovenian
		#LANGUAGE="sl_SI:sl"
		LANG="sl_SI.UTF-8"
		KEYTABLE="slovene"
		XKBLAYOUT="si,us"
		TZ="Europe/Ljubljana"
                FLUX="sl"
		COUNTRY="Slovene"
                MIRROR="ftp.si.debian.org"
		;;
        al|sq|sq_AL)
		## Albanian
		#LANGUAGE="sq_AL:al"
		LANG="sq_AL.UTF-8"
		KEYTABLE="us"
                XKBLAYOUT="sq,us"
		TZ="Europe/Tirana"
                FLUX="sq"
		COUNTRY="Albanian"
                MIRROR="ftp.gr.debian.org" #nearest?
		;;
        sr|sr_RS)
		## Serbian
		#LANGUAGE="sr_RS:sr"
		LANG="sr_RS.UTF-8"
		KEYTABLE="sr"
                XKBLAYOUT="sr,us"
		TZ="Europe/Belgrade"
                FLUX="sr"
		COUNTRY="Serbian"
                MIRROR="ftp.gr.debian.org" #nearest?
		;;
        sv|sv_SE)
		## Swedish
		#LANGUAGE="sv_SE:se"
		LANG="sv_SE.UTF-8"
		KEYTABLE="se-latin1"
                XKBLAYOUT="se,us"
		TZ="Europe/Stockholm"
                FLUX="sv"
		COUNTRY="Swedish"
                MIRROR="ftp.se.debian.org"
		;;
	tr|tr_TR)
		## Turkish
		#LANGUAGE="tr_TR:tr"
		LANG="tr_TR.UTF-8"
		KEYTABLE="tr_q-latin5"
		XKBLAYOUT="tr,us"
		TZ="Europe/Istanbul"
                FLUX="tr"
		COUNTRY="Turkish"
                MIRROR="ftp.tr.debian.org"
		;;
	tw|zh_TW)
		## Traditional Chinese
		#LANGUAGE="zh_TW:zh"
		LANG="zh_TW.UTF-8"
		KEYTABLE="us"
		XKBLAYOUT="us"
		TZ="Asia/Taipei"
                FLUX="en"
		COUNTRY="Chinese"
                MIRROR="ftp.tw.debian.org"
		;;
        ua|uk_UA)
		## Ukrainian
		#LANGUAGE="uk_UA:ua"
		LANG="uk_UA.UTF-8"
		KEYTABLE="ua"
		XKBLAYOUT="ua,us"
		TZ="Europe/Kiev"
                FLUX="ua"
		COUNTRY="Ukrainian"
                MIRROR="ftp.ua.debian.org"
		;;
	uk|en_GB)
		## British
		#LANGUAGE="en_GB:en"
		LANG="en_GB.UTF-8"
		KEYTABLE="uk"
		XKBLAYOUT="gb"
		TZ="Europe/London"
                FLUX="en"
		COUNTRY="GB-English"
                MIRROR="ftp.uk.debian.org"
		;;
	us|en_US)
		## American
		#LANGUAGE="en_US:en"
		LANG="en_US.UTF-8"
		KEYTABLE="us"
		XKBLAYOUT="us"
		TZ="America/New_York"
                FLUX="en"
		CD_COUNTRY="US-English"
                MIRROR="ftp.us.debian.org"
		;;
	*)
		## American
		#LANGUAGE="en_US:en"
		LANG="en_US.UTF-8"
		KEYTABLE="us"
		XKBLAYOUT="us"
		TZ="America/New_York"
                FLUX="en"
		COUNTRY="US-English"
                MIRROR="ftp.us.debian.org"
		;;
 esac

 # trump XKBLAYOUT if set at boot
 if isbootparam "kbd"; then
    XKBLAYOUT="$(getbootparam kbd 2>/dev/null)"
    echo -ne "\e[33m" 
    echo -n "Setting keyboard for ${XKBLAYOUT} ."
    echo ""
    echo -ne "\e[0m"
 else
    echo -ne "\e[33m"
    echo -n "Setting keyboard for ${XKBLAYOUT} ." 
    echo "" 
    echo -ne "\e[0m"
 fi

 # trump XKBVARIANT if set at boot
 if isbootparam "kbvar"; then
    XKBVARIANT="$(getbootparam kbvar 2>/dev/null)"
    echo -ne "\e[33m" 
    echo -n "Setting keyboard variant to ${XKBVARIANT} ."
    echo ""
    echo -ne "\e[0m"
 fi
 
 # trump XKBOPTIONS if set at boot
 if isbootparam "kbopt"; then
    XKBOPTIONS="$(getbootparam kbopt 2>/dev/null)"
    echo -ne "\e[33m" 
    echo -n "Setting keyboard options to ${XKBOPTIONS} ."
    echo ""
    echo -ne "\e[0m"
 fi

 LOCAL=/usr/share/antiX/localisation
 BIN=/usr/local/bin
 cp -r $LOCAL/$FLUX/local-bin/* $BIN

 # Only clobber /home/demo files if it is empty of hidden files
 DEMO=/home/demo
 if ! ls $DEMO/.[a-z]* &> /dev/null; then
     [ -e $DEMO ] || mkdir -p $DEMO
     cp -r /etc/skel/.[a-zA-Z]* $DEMO 2>/dev/null
     cp -r /etc/skel/* $DEMO 2>/dev/null
     # set lang for fluxbox and icewm menus
     echo -ne "\e[33m"
     echo -n "Internationalising fluxbox and icewm menus for $COUNTRY... "
     cp $LOCAL/$FLUX/fluxbox/menu-$FLUX $DEMO/.fluxbox/menu
     cp $LOCAL/$FLUX/fluxbox/gnome2fluxmenu4.py $DEMO/.fluxbox
     cp $LOCAL/$FLUX/icewm/menu-$FLUX $DEMO/.icewm/menu
     cp $LOCAL/$FLUX/icewm/toolbar $DEMO/.icewm
     cp $LOCAL/$FLUX/icewm/icemenuyap2.py $DEMO/.icewm
     echo "done."
     echo -ne "\e[0m"

     # symlink wallpaper
     WPDIR=/usr/share/wallpaper
     mkdir -p $DEMO/Wallpaper
     for wp in $(ls $WPDIR); do
         rm -f $DEMO/Wallpaper/$wp 
         ln -s $WPDIR/$wp $DEMO/Wallpaper/$wp
     done

     chown -R demo:users $DEMO 2>/dev/null
 fi

 #dpi cheat. Useful for netbooks?
 if isbootparam "dpi"; then
   DPI="$(getbootparam dpi 2>/dev/null)"
   sed -i -e "s/^xserver_arguments.*/xserver_arguments -dpi $DPI -nolisten tcp/" /etc/slim.conf
   sed -i -e "s/^xserver_arguments.*/xserver_arguments -dpi $DPI -nolisten tcp/" /usr/share/slim/themes/antiX/slim-install.conf
 fi

 # Remove Rox-pinboard
 if isbootparam "noRox"; then
    cp $DEMO/.fluxbox/startup $DEMO/.fluxbox/startup.bak
    cp $DEMO/.icewm/startup $DEMO/.icewm/startup.bak
    echo "Disabling Rox desktop"
        sed -i -e "s/rox --pinboard=antiX-ice &/#rox --pinboard=antiX-ice &/" \
        $DEMO/.icewm/startup
        sed -i -e "s/rox --pinboard=antiX-fb &/#rox --pinboard=antiX-fb &/" \
        $DEMO/.fluxbox/startup
        sed -i -e 's/fehbgrox-fb/fehbgfb/g' $DEMO/.fluxbox/startup
        sed -i -e 's/fehbgrox-ice/fehbgice/g' $DEMO/.icewm/startup
        chown demo $DEMO/.icewm/startup
        chown demo $DEMO/.icewm/startup.bak
        chgrp users $DEMO/.icewm/startup
        chgrp users $DEMO/.icewm/startup.bak
        chown demo $DEMO/.fluxbox/startup
        chown demo $DEMO/.fluxbox/startup.bak
        chgrp users $DEMO/.fluxbox/startup
        chgrp users $DEMO/.fluxbox/startup.bak
    cp $DEMO/.fluxbox/startup /etc/skel/.fluxbox
    cp $DEMO/.fluxbox/startup.bak /etc/skel/.fluxbox
    cp $DEMO/.icewm/startup /etc/skel/.icewm
    cp $DEMO/.icewm/startup.bak /etc/skel/.icewm
 fi  
 
 # Change default desktop
 if isbootparam "desktop"; then
    DESKTOP_CODE="$(getbootparam desktop 2>/dev/null)"
    case "$DESKTOP_CODE" in
        fluxbox)
        DEFAULT_DESKTOP="startfluxbox"
        ;;
        icewm)
        DEFAULT_DESKTOP="icewm-session"
        ;;
        lxde)
        DEFAULT_DESKTOP="startlxde"
        ;;
        xfce)
        DEFAULT_DESKTOP="startxfce4"
        ;;
        wmii)
        DEFAULT_DESKTOP="wmii"
        ;;
        dwm)
        DEFAULT_DESKTOP="dwm"
        ;;
        fvwm-crystal)
        DEFAULT_DESKTOP="fvwm-crystal"
        ;;
        kde)
        DEFAULT_DESKTOP="startkde"
        ;;
        gnome)
        DEFAULT_DESKTOP="gnome-session"
        ;;
        openbox)
        DEFAULT_DESKTOP="openbox-session"
        ;;
        *)
        echo "ERROR: unknown desktop: \"$DESKTOP_CODE\""
        echo "Try fluxbox instead."
        ;;
    esac
    if [ $DEFAULT_DESKTOP ]; then
        echo "Setting default desktop in ~/.xinitrc to $DESKTOP_CODE"
        sed -i -e "s/XINITRC_DEFAULT=.*/XINITRC_DEFAULT=$DEFAULT_DESKTOP/" \
        $DEMO/.xinitrc
        cp $DEMO/.xinitrc /etc/skel/.xinitrc
    fi
 fi

# localise /etc/apt/sources.list
 if [ -n "${MIRROR}" ] && [ -f /etc/apt/sources.list ] && \
    [ ! -f /persist-root/etc/apt/sources.list ]; then
        echo "Localizing /etc/apt/sources.list to $MIRROR"
		sed -i 's|/ftp\.\(..\.\)\?debian\.org/|/'"${MIRROR}"'/|' \
			/etc/apt/sources.list
 fi

# set keyboard in fluxbox and icewm startup -live only
sed -i -e "s/^setxkbmap.*/setxkbmap -layout "$XKBLAYOUT" -option "$XKBOPTIONS" -variant "$XKBVARIANT"/" $DEMO/.fluxbox/startup
sed -i -e "s/^setxkbmap.*/setxkbmap -layout "$XKBLAYOUT" -option "$XKBOPTIONS" -variant "$XKBVARIANT"/" $DEMO/.icewm/startup
sed -i -e "s/^setxkbmap.*/#setxkbmap/" /etc/skel/.fluxbox/startup
sed -i -e "s/^setxkbmap.*/#setxkbmap/" /etc/skel/.icewm/startup

# localising for install
 TRANS=/usr/share/antiX-install
 echo -n "Saving live config. to antiX ..."
 cp /etc/default/locale $TRANS
 cp -p /usr/share/antiX/localisation/$FLUX/fluxbox/menu-$FLUX $TRANS/fluxbox
 cp -p /usr/share/antiX/localisation/$FLUX/fluxbox/gnome2fluxmenu4.py $TRANS/fluxbox
 cp -p /usr/share/antiX/localisation/$FLUX/icewm/menu-$FLUX $TRANS/icewm
 cp -p /usr/share/antiX/localisation/$FLUX/icewm/toolbar $TRANS/icewm
 cp -p /usr/share/antiX/localisation/$FLUX/icewm/icemenuyap2.py $TRANS/icewm
 echo "... done."

do_confxorg() {
   if [ -f /etc/X11/xorg.conf -a -d /persist-root ]; then
       if isbootparam "autox"; then
           return 0
       else
           return 1
       fi
   else
       if isbootparam "noxorg"; then
       echo -n "Not creating /etc/X11/xorg.conf file... "
       # set kb for /default/keyboard
 	cat > /etc/default/keyboard <<EOF
XKBMODEL="${XKBMODEL}"
XKBLAYOUT="${XKBLAYOUT}"
XKBVARIANT="${XKBVARIANT}"
XKBOPTIONS="${XKBOPTIONS}"
EOF

       echo "ok."
           return 1
       else
           return 0
       fi
   fi
}

# automatic XOrg Setup
if do_confxorg; then
    if [ -z "$INSTALLED" ]; then
        echo -n "Creating /etc/X11/xorg.conf file... "
        /usr/sbin/buildxconfig
        # set kb for xorg
        sed -i "s/XkbLayout.*/XkbLayout\" \"$XKBLAYOUT\"/g" /etc/X11/xorg.conf
        # set kb for /default/keyboard
 	cat > /etc/default/keyboard <<EOF
XKBMODEL="${XKBMODEL}"
XKBLAYOUT="${XKBLAYOUT}"
XKBVARIANT="${XKBVARIANT}"
XKBOPTIONS="${XKBOPTIONS}"
EOF

        echo "done."
    else
        if isbootparam "autox" ; then
            echo -n "Reconfiguring /etc/X11/xorg.conf file... "
            mv -f /etc/X11/xorg.conf /etc/X11/xorg.conf.bak
            /usr/sbin/buildxconfig
            echo "done."
        fi
    fi
fi
fi
echo -n "Updating fstab... "
# Add new entries to /etc/fstab
buildfstab -r >/dev/null 2>&1

echo "done."
# for lmsensors
mknod /dev/i2c-0 c 89 0 >/dev/null 2>&1

# for ntfs mount
chmod 4755 /usr/bin/ntfs-3g >/dev/null 2>&1

echo "6" > /proc/sys/kernel/printk

# Re-enable signals
trap 2 3 11

exit 0
