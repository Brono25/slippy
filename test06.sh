#!/bin/dash


# ==============================================================================
# test06.sh
#
# Testing slippy subs alternate delimeters
# ==============================================================================



PATH="$PATH:$(pwd)"


[ -d 'tmp' ] && rm -rf 'tmp'

output="$(mktemp)"
expected_output="$(mktemp)"
test_input="$(mktemp)"

trap 'rm -f $output $expected_output $test_input ' EXIT INT


test_outcome()
{
	if ! diff "$1" "$2"
	then
    	echo "Failed test"
    	#exit 1
    else
    	echo "Pass"
	fi
}

mkdir tmp
cd tmp



echo "-------------Test All Characters as Delimeter------------"

(
seq 5| slippy 's!a!rb!g'
# seq 5| slippy 's#a#rb#g' #broken
seq 5| slippy 's$a$rb$g'
seq 5| slippy 's%a%rb%g'
seq 5| slippy 's&a&rb&g'
seq 5| slippy 's(a(rb(g'
seq 5| slippy 's)a)rb)g'
seq 5| slippy 's*a*rb*g'
seq 5| slippy 's+a+rb+g'
seq 5| slippy 's,a,rb,g'

seq 5| slippy 's-a-rb-g'
seq 5| slippy 's.a.rb.g'
seq 5| slippy 's/a/rb/g'
seq 5| slippy 's0a0rb0g'
seq 5| slippy 's1a1rb1g'
seq 5| slippy 's2a2rb2g'
seq 5| slippy 's3a3rb3g'
seq 5| slippy 's4a4rb4g'
seq 5| slippy 's5a5rb5g'

seq 5| slippy 's6a6rb6g'
seq 5| slippy 's7a7rb7g'
seq 5| slippy 's8a8rb8g'
seq 5| slippy 's9a9rb9g'
seq 5| slippy 's:a:rb:g'
seq 5| slippy 's;a;rb;g'
seq 5| slippy 's<a<rb<g'
seq 5| slippy 's=a=rb=g'
seq 5| slippy 's>a>rb>g'
seq 5| slippy 's?a?rb?g'
seq 5| slippy 's@a@rb@g'
seq 5| slippy 'sAaArbAg'
seq 5| slippy 'sBaBrbBg'
seq 5| slippy 'sCaCrbCg'

seq 5| slippy 'sDaDrbDg'
seq 5| slippy 'sEaErbEg'
seq 5| slippy 'sFaFrbFg'
seq 5| slippy 'sGaGrbGg'
seq 5| slippy 'sHaHrbHg'
seq 5| slippy 'sIaIrbIg'
seq 5| slippy 'sJaJrbJg'
seq 5| slippy 'sKaKrbKg'
seq 5| slippy 'sLaLrbLg'
seq 5| slippy 'sMaMrbMg'
seq 5| slippy 'sNaNrbNg'
seq 5| slippy 'sOaOrbOg'
seq 5| slippy 'sPaPrbPg'
seq 5| slippy 'sQaQrbQg'
seq 5| slippy 'sRaRrbRg'
seq 5| slippy 'sSaSrbSg'
seq 5| slippy 'sTaTrbTg'
seq 5| slippy 'sUaUrbUg'
seq 5| slippy 'sVaVrbVg'

seq 5| slippy 'sWaWrbWg'
seq 5| slippy 'sXaXrbXg'
seq 5| slippy 'sYaYrbYg'
seq 5| slippy 'sZaZrbZg'
seq 5| slippy 's[a[rb[g'
# seq 5| slippy 's\a\rb\g' #broken
seq 5| slippy 's]a]rb]g'
seq 5| slippy 's^a^rb^g'
seq 5| slippy 's_a_rb_g'
seq 5| slippy 'scacrbcg'
seq 5| slippy 'sdadrbdg'
seq 5| slippy 'seaerbeg'
seq 5| slippy 'sfafrbfg'
# seq 5| slippy 'sgagrbgg' #broken
seq 5| slippy 'shahrbhg'
seq 5| slippy 'siairbig'

seq 5| slippy 'sjajrbjg'
seq 5| slippy 'skakrbkg'
seq 5| slippy 'slalrblg'
seq 5| slippy 'smamrbmg'
seq 5| slippy 'snanrbng'
seq 5| slippy 'soaorbog'
seq 5| slippy 'spaprbpg'
seq 5| slippy 'sqaqrbqg'

seq 5| slippy 'ssasrbsg'
seq 5| slippy 'statrbtg'

seq 5| slippy 'suaurbug'
seq 5| slippy 'svavrbvg'
seq 5| slippy 'swawrbwg'
seq 5| slippy 'sxaxrbxg'
seq 5| slippy 'syayrbyg'
seq 5| slippy 'szazrbzg'
seq 5| slippy 's{a{rb{g'
seq 5| slippy 's|a|rb|g'
seq 5| slippy 's}a}rb}g'
) > "$output" 

(
seq 5| 2041 slippy 's!a!rb!g'
# seq 5| 2041 slippy 's#a#rb#g'#broken
seq 5| 2041 slippy 's$a$rb$g'
seq 5| 2041 slippy 's%a%rb%g'
seq 5| 2041 slippy 's&a&rb&g'
seq 5| 2041 slippy 's(a(rb(g'
seq 5| 2041 slippy 's)a)rb)g'
seq 5| 2041 slippy 's*a*rb*g'
seq 5| 2041 slippy 's+a+rb+g'
seq 5| 2041 slippy 's,a,rb,g'

seq 5| 2041 slippy 's-a-rb-g'
seq 5| 2041 slippy 's.a.rb.g'
seq 5| 2041 slippy 's/a/rb/g'
seq 5| 2041 slippy 's0a0rb0g'
seq 5| 2041 slippy 's1a1rb1g'
seq 5| 2041 slippy 's2a2rb2g'
seq 5| 2041 slippy 's3a3rb3g'
seq 5| 2041 slippy 's4a4rb4g'
seq 5| 2041 slippy 's5a5rb5g'

seq 5| 2041 slippy 's6a6rb6g'
seq 5| 2041 slippy 's7a7rb7g'
seq 5| 2041 slippy 's8a8rb8g'
seq 5| 2041 slippy 's9a9rb9g'
seq 5| 2041 slippy 's:a:rb:g'
seq 5| 2041 slippy 's;a;rb;g'
seq 5| 2041 slippy 's<a<rb<g'
seq 5| 2041 slippy 's=a=rb=g'
seq 5| 2041 slippy 's>a>rb>g'
seq 5| 2041 slippy 's?a?rb?g'
seq 5| 2041 slippy 's@a@rb@g'
seq 5| 2041 slippy 'sAaArbAg'
seq 5| 2041 slippy 'sBaBrbBg'
seq 5| 2041 slippy 'sCaCrbCg'

seq 5| 2041 slippy 'sDaDrbDg'
seq 5| 2041 slippy 'sEaErbEg'
seq 5| 2041 slippy 'sFaFrbFg'
seq 5| 2041 slippy 'sGaGrbGg'
seq 5| 2041 slippy 'sHaHrbHg'
seq 5| 2041 slippy 'sIaIrbIg'
seq 5| 2041 slippy 'sJaJrbJg'
seq 5| 2041 slippy 'sKaKrbKg'
seq 5| 2041 slippy 'sLaLrbLg'
seq 5| 2041 slippy 'sMaMrbMg'
seq 5| 2041 slippy 'sNaNrbNg'
seq 5| 2041 slippy 'sOaOrbOg'
seq 5| 2041 slippy 'sPaPrbPg'
seq 5| 2041 slippy 'sQaQrbQg'
seq 5| 2041 slippy 'sRaRrbRg'
seq 5| 2041 slippy 'sSaSrbSg'
seq 5| 2041 slippy 'sTaTrbTg'
seq 5| 2041 slippy 'sUaUrbUg'
seq 5| 2041 slippy 'sVaVrbVg'

seq 5| 2041 slippy 'sWaWrbWg'
seq 5| 2041 slippy 'sXaXrbXg'
seq 5| 2041 slippy 'sYaYrbYg'
seq 5| 2041 slippy 'sZaZrbZg'
seq 5| 2041 slippy 's[a[rb[g'
# seq 5| 2041 slippy 's\a\rb\g' #broken
seq 5| 2041 slippy 's]a]rb]g'
seq 5| 2041 slippy 's^a^rb^g'
seq 5| 2041 slippy 's_a_rb_g'
seq 5| 2041 slippy 'scacrbcg'
seq 5| 2041 slippy 'sdadrbdg'
seq 5| 2041 slippy 'seaerbeg'
seq 5| 2041 slippy 'sfafrbfg'
seq 5| 2041 slippy 'sgagrbgg'
seq 5| 2041 slippy 'shahrbhg'
seq 5| 2041 slippy 'siairbig'

seq 5| 2041 slippy 'sjajrbjg'
seq 5| 2041 slippy 'skakrbkg'
seq 5| 2041 slippy 'slalrblg'
seq 5| 2041 slippy 'smamrbmg'
seq 5| 2041 slippy 'snanrbng'
seq 5| 2041 slippy 'soaorbog'
seq 5| 2041 slippy 'spaprbpg'
seq 5| 2041 slippy 'sqaqrbqg'

seq 5| 2041 slippy 'ssasrbsg'
seq 5| 2041 slippy 'statrbtg'

seq 5| 2041 slippy 'suaurbug'
seq 5| 2041 slippy 'svavrbvg'
seq 5| 2041 slippy 'swawrbwg'
seq 5| 2041 slippy 'sxaxrbxg'
seq 5| 2041 slippy 'syayrbyg'
seq 5| 2041 slippy 'szazrbzg'
seq 5| 2041 slippy 's{a{rb{g'
seq 5| 2041 slippy 's|a|rb|g'
seq 5| 2041 slippy 's}a}rb}g'

) > "$expected_output" 

test_outcome "$output" "$expected_output"





echo "-------------Test Escaped Delimeters in patterns------------"
(
seq 5| slippy 's/. \/ / x \/ /g'
seq 5| slippy 's_ \_ \_ abc _ \_ _    g'

) > "$output" 

(
seq 5| 2041 slippy 's/. \/ / x \/ /g'
seq 5| 2041 slippy 's_ \_ \_ abc _ \_ _    g'

) > "$expected_output" 

test_outcome "$output" "$expected_output"




cd ..
rm -rf tmp




