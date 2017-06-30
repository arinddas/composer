ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.9.1
docker tag hyperledger/composer-playground:0.9.1 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� LnVY �=Mo�Hv==��7�� 	�T�n���[I�����hYm�[��n�z(�$ѦH��$�/rrH�=$���\����X�c.�a��S��`��H�ԇ-�v˽�z@���W�^}��W�^U��r�b6-Ӂ!K��u�lj����0!��F�������6�r|L8�B�e ��_-Ǖm ���֜��&���Bڎfk`�[�(�mM��E��	{}�_�+k���	���$Rk�u��Z�֡Z�v��R�2m�� �W�f��L ��l�hB��!%��B�,�����F&���# x���VaMn�n�4���P۬i:�� ��kr���E0�2�� �`� �r8�ᚸ2w�'G�5�����6H�f��h:!�9�����ݕ��k�+�0��_�p���J�!��kMh�\�2�0#���B�
�f(�TIѲu�Eݶ��H�O�gr��a��gx�Iz1�v��!�"�7��#XM�ʤ0Nޮ��raC��4�%�׵�<�tl$�@���b�	�T�6<mA��)m*���MT�aVG{	���$M�Gt�6����-���&�3�Tq'�M��K._�)K���{����W�E]~���	~���d��mC�{C��w��R�=X��"��v���F����q���Co���d���H% ��s2>��L��P�U�cxT�iܖi���g9�?������1.�������T5#R���-[��~�(*��j6
����X�<*�wJI�����h������+r��2��Qg�!�?`#�X�qsޫ��х����q���d�-��ǎi�	b��]i�aY^ �/��9l������ ^�W������h�H�Q�0�z�ö�[�e� ��f]0���� *1~��i��Xꦅ�>H�t\`�l����l�-��G�nA$�܆iU<l]S����37`��"N`����E8��M�Di�h1�1鲩�p���|�ԂZ�*Z�@ԫ,E)�����Pq�LH֭��-����canq��P�������i����-MWC��4�6a���t�B��c���]#8 	�e^��Sc��1	�hx��+��k^���U^ja?fu(��&�K�S��Ⴣk�������mU�	�� eo`�G!�b�7��c��<Pk�(܆�M��`mæن(�e�Q��p�~"�5��ϨwU`ן<UI�B��(��`m��"�u@���K���F�4L@o!z8o��C�5���1Z��-y�'ə�i�87H\R箤^쑟���$C�a��7�hk��8@v@�,�5桐:+\2�cc��f��&3諒�is`��`MŸ�����>CO��Hl��츟$}��3�ϕ!�5ԋLC�J	Ա�΍A��`vqlo�
�^���(�bKsI"̻j�Ϯ�@��P�rt�.�Pv p�t�� &�n�w���Og�)��k@*�~�C������g��Q� �������O���%b��U�$����z��3"R/��P>y��q�rѫ���	k�i�Y�TӀ���c�1�?�Dwf��0��G����\`a���a��_��ј �,���va��x:R����if�Ɂ�f����yX�M������媧��l�F���v�JeJ�7N��f�|TN�2����hl�~2�����J��`�ɻ ��2f�(ʡs��n��R&y�+�ʙ|���ť��+�@s@�p��)�N��	x8�{.��뾃u^�'�/��F!f�Je��rE,U�*���ߩ\�� �8�Y<u j,�y6R����,��6\_��&����╅�
�y��%��s�Ć��[�_���JV�@��20Z�*�i����K����u2���:��W+�d��]���hz�[ z���$6f�WЪ���U��w��`f��c��o>���>n���m�.���?�2��_<�,�p��O=����ذ�@3P��:�,ִ3Л�Q�}��}1�������t{��ƙ8����Ln��a��-�����o����a��E�����o�<����������g.0��+�U�i�5��� ڶi� ����!�lʆ�)��������@(�r��]=���$�M��븰	���K8�B5�)��|���1F4gI����#U�GZs�av��C�@Q�]X�<����ut����\�W�Sh��!�~	���]�U�Y9�\��,���t�q�H�O/�7w�(�̨�s�B�����G�����i�ʞ��2q@�܀ўsAo�N<��F�Ş�GB,Ą�0�K�IM��zL�ۛ/����oO\�s�!���B���U���@p�T�>�0���ISY)�Tg�1���a�a�?˳�B������a�-k�̇�!V?H�^�o�-8��#:���!�� ��f�y���z ��3�ˬ{\R��[��5#�"���o��� ����%
94G�Gj����4!vyp�U�����C7Yo���}��r^����c�U�7���B�ɻ�|V�_��4*�t��'knE�N�E����h�'0ɢH���P��̃sK��:XCv@B�oh���:BF��~D�w�����iiL��ؘ���Ll1����n+��1�x������+��HE��e��0�B\	��ꅓf�lB*�K�ɣ�x$�RNLlK�u|� �m1׳�G�q1�ʩ�@KF�`�C�`H������d�$$�t$�R%�\w*��T���nm7�J�*�3��z����(i�v�n���'�d;�Ngr�miW�^OI����Lj��Hpa+s$��+`��-�e,ve6���4�e)�S�T��
�R~{�ۮ���4��~���z��o5˥�U� l]3N�>����i���B�/�*�0U�Kƭ�6�V���Dk��[h�f����-h��?&��H��<�����ѳ��]Ar�@˺B/�i� �RA(D���������ޭa���*�W�P@_�x���\�c~��X�m�+�Eo�,v}2�F=�N��[yM��A�G�����������K�&��ϡ��F��Ϲ����{S�B�w�_Q<:)̴�|�H�x:����B��f0"[6A���3z��5
�^�@�#�W�p���}w��#L;���R���ld����>����8�`+@Ͻƻ��
]yR*E�A�ٓ�ק߀��RjuL���Z��ͥ������hX����_�OV�-UM��pA�τ��]5�N8��1xM+��9<i�������
�bq~����V�����zx]3�<0f��V�3���"@`_�r����n���@~�b�$p~N�Q�;�X�V�39*��;�?������_�y/��+|
�e���ne�y�a߆+_R��=>�2���'RƺF���ye�?"�^H�LW�K�{k�wk�z�&�*���&��m;��&��{��c���_6�-�����f�1{�G�E��n���W���1���C3�P��n������p�ݭx��T֟�h�$���m��\C�&{��((^��2e���;J�����Wc�{�]������g�j��ɵ(���*/��QAQ��D՚P]]��	��
�EkJM��*W	���;�p�-D}/hڮV�rw<�ҙHJ�Jf#�+	=4��Lr�8��t]�db=S�����������[��4�ŭD�~�89��Ŕx��d�N��H�S��bZ���9�*YDJdw�d"�U�6y4yk�"�eE�8��v��VF:��{���:w\=��	�K����WF���0��*�3}��kW+�8♇s8K��,w.2���Y�X��*2
�zab?,�ᜡR�����nBܯ��n%[�v$�d�c���ά��j�����~gC$q�R������F�xը6s������Jg�K�J%i֪�$P=(g�����۩�wZ�ܪ��8�H���Cc�<Ȝ3I����SbQI뢔j��Ս�D��Z�󺼹�׎Yn�a����䡱�KJvb��y��:J�؎���kc�p�wv��A�|�L�xAɝl7ۂ�Ӳi���#^KL�������ڷ�W�&����W�b6+��d�I�ŝ���!qRGJD:�dV;[��ԡ��9N$���)�M�k����S��p������7_�Ȧ��Ze.���r�l��d�+����-���*u�NI�ԫ�閹eo���i�P��q�Oo��6^>����5}U9�Z�̤�ʡ�S*,&�~uuu�9_=;�h;HJ�W�S#�>h�ϙx�}h1�r�1�A_\\��8����H8��mӨok���k��D��˰��0}]�A� #< �����i���M��=�����C�E��.�����&*�����?�:q���E�>ؒ�I�#*�Io�uI��O�{�.gc��7���H3���b��l?߃��k�;{��G�mַ[+����cUf�����kr��J�QsIQ,�c�+g�(q���DR	5�XrD3R��G+�JF}]ϔ�T-)����s�ݶ�J�2��JeC=ᷳ�W�Ŗ�Q}�f�`�]�|�lt����<����V�������ύ�����@p��Ilg����7�����df6��׃�0g�]k?�Y����a�lJ��?����nq��|��է�;jﳇ_��_�����ҟ�[����+P�՚��
�1�*�sQVU���U8!Z��16��d����*0�
�*�"��,��~�/�!������<��?��������������.�~������%ѥ��3�'�e��l���җK?�~���\�\Xz��`ɏ/i�J��cڮ�j.����E�8\�~�O�,��'�Y�}��@>�/���g鋥?���%�����(��{��"9Y���G(��~ �+A|!u ����a��BT������������������_�����������?/}��Sd�e����f���5 �_`����|tq��|��y,s������уN9�����&�������I�G؋f=]%26S�S�IX�J�R	�D�� �?p) NJ��)�\|��������0F�k3�S�U��-A�B8���^�'�;[~2ҷ���UN��||��2�Q�&5E�5V��XY�Q�o�S��jmU�c�(s�|䜀P�s�[#�[R�����
#5�k�f�:��B�lh�d ���$�q�:{�ɤ�3=�(����L�遅n"E5��p%Q��E���*REQ*J:�!�����࣓��	Āa�	�� 9�=r��CJ�*UI�tWw�<�W@u����������1��~��^�۬����8ف~xNޒ�R�6����[�׋��/�٪İR,q[a%��4lX�j0-}�\�V���j�(y}z�s!w�\�V)T�G���+X������G~<U�G�5�B7�H������h�+�"���?Wr'i�O���j���Q�8�Mw��>�Ǡ�����qǝ������:s��U��ṕ~��c�p/�{ST�G���U���م���s'�-������"Qr��h������
?鍑�n�\��H���?��5����e~A�υk���-Iz�\6��\��^�s�A��8] ���\���m�,݅Y��)���V�E�F*��k6yvp˩�v��%����~5�I�Om��󣤃\h���5\�e]����#�'{�:�,�Ov`��H^��0-�n�+I0�i�'&�h5;��4R����#�S�Ti>�z���,��q�UU��tl�>^u|;7�,����
������)�����.᧫u��P����w<���\X���>���.8�kv�O>\}���<�ۋ�nVx}��,�&]�'����5����M'���/�8�~�+�i��>��f�,�-%a�ʹ<x�m~ae��9N$�T춠$C=�K��7�����e/���3�(�O=���ՠ�����������0����
����G���J����W�?������>��G�����~O3�I�������̀�<x�͗_9�ǯ&��ג|ۅ�p�/��n�����X.�������L��fP��q�@(�g�!�;�je�M\O�ޭK�������������������_��7R?T�VR���~���i�,L������%���茶��i��/�9�ݷ��'��۩�����N��Kr��$5Xfh�����`�����A��3.���ǃtW3N�7W�����e@ ��lߎ@��0e礴̱u�[��\����I��N�Y_3F�����DCzs!��B6���r�Yk�NZ�NGoRaK�<��x���)*t���Q�)��	^i$�y�Ϣ��<*��$8I��M��LT��*�T���<�#��辪�M�����DN� O��r5h���f�����pߋ�g���8$$��V�Zh�L�öxm�df���,��9���JF� �Y�#Eʑ��I�r��yJ4C��`���	�RH&�9����R4��ܞ#+@=]�[G�*a���q+�i�HE�m{�ӝJ�d�<��(k���@�u+A�>u
�Fx��%Jʕ�b�H�W�	�.�6<u�Z��:P�����Evl晾�A��T��"��M��e����+V�'�J◫*������YI �� DQ��Ԟ�]�4y"Â��k7�xl��a�9��G*��FL��E';�j�3%�*�Rėl� i��$w�pI<f�P����=}L����}p�a,;L�"���<ꌳ�n�!8�����.ª�^�E�S=�.P��$�@j�PФH.��%�JQ�ϋ�(�R���*̘��� cU@�Z�Y�DM���y�3��,�����MB)�u�HN�4����\�I208ʇ�5�y��6[e.���\�M�!�H0�šd�����̏[�W(O�+��7zY$���D�v*,�3��@N	����Y�ɷ�2#��,R��$�sV�F�Y�X���s��&��D�6��y�Q�;P��_og6���'R�	j����6j6����*)z�a9�|��Ba)�2$�7�����txd�A����!A�Є+�J�-��	/�e6��u,(�)U��_��,\�-5j�U/V:S�Ҥs�������&�<�M+y��� 7��nZ�ܴ��ip��%<�M+x��� ׭߹d�Po /�I�������V�{��V���~���;���+�?s��ג��y|r|�1� �K1��N�����x�79���M�w�S�������8�ֽ��������������wi~�x��h��t,%:���ȧ���vb��c�o0�5�ݽ���tM���Ҥ @�r^ڕ�3�z���L��+���P��lM
�*�Qly�F�h>l+����5͙ ��R�ƌU"2�o�x�8E��p=m�Z�v��zp���`�l�C�M���+hN�4���Β.�4����Rhs��jc��g��dà;R:�B;T'Nѱ<��:͆k����d]�L(�V7��t����>(>cKzNa��KVM����+e��{�8.U��U���R�`ynԝ6ᨓ1�q�l�f��ˋ�V+B'�v$�;�lFd2{#�	2u�q�p�*-!�0_���kJ[o{������S�J]Xe�}p0@Jf��ihJ����Gy�Q9�95���1��U,Yjf\#�����j�؎���d��9�<1��0U��,�j�jZ��T����B�*�%bՀ�P�L���TIv
�M�"O�b��P��{o�ˬ;:i�����s�Y�����O?��Ot�ߧ��/�-R�N�� 8�H��������}����o>8s��WBL%q���Tq��8 �Z.�'e�E���	7w�{֊;ϐ�⦑s�Q#�Y�]6��
�İ�i�uT�V�QX{4~��V�x�K&�X>ob4R�����"u
�EEI�� �#gF�;�3�H����Xw7��5ւ��&�G��c�Hr��/tJe+S�M5�Sёo��Z�b}t.pݠ"�H7j��j2@A$�:6q<�Z�-]�E��>����$��Q�X/Ħ��s� %�'�"�16ĸ3'��-fآ#:x���E�C�`�"�u���-O}�td�z$:�� nd�K#� &��Y���,뵐F6S�]�B�6Zb���ZO1��H���c����ӣzP$�Ee��ǃBu Ѩ�M��[��<���N;c�ѥ�o]/1�,���K�ޚDQ9^�V�������� `�q������ !���@8`��n���P�b��t&�t,�S9� F���%]��Fc,�0����%pɘ�v>8<Vȫ͹���Mh�ݝ��5�X�6X��NhM%Aو�����ǁ����H��#K�l:���ZӁ��ʸ��F�S�jj�7�y�fb����A��
A�������m��rƏjC��a���$�ڥB���ؽ������s��9^�}�}�j���V}ƢU�������w�v%a1�k��֤v1D�!�@�H�mB�Ok�!���~đ����q8�ڈ
��#�.��)�`̲�!Ub,�F�FY�����p"ؕ�ǌT)�$�4`��VC�װ��oX��KPc�I�c]�y��Q�~�˸C��2|����:��tx��͓�j0�Zt��{�|^��j��\w4�Z��U%��E#kP���xm�t��z �[�Ks���4F규<�{���x�Q�-�m�<?j*�K�5���p��cԊ9X%@��j�ȱ��������o^W�0���F?H}����Z����둽�����?	9	�^�����/���hJV8����a�����W�{I��5'�2Z�7S� /�~�?<-�}�j����έ�[���7?��{�|r�2�/x�e���ϧ~�Y��'����;�w�U����;窉�x�������'<_�@%y�j���狮w2T�o�z�����1S��J%1߳�!��ŵ����:A�&Ƣ�8�����vxs5?�i��0��ԯ��w�U�%EZ�|0�1�'�p |n���S�Y/���=���w����߷A7��Ͳ�-�x��G!A������l�i�E!x?��Aw��o������n����_�j��{�i;���?�����۠�����,����6����Z�]���������?�n�v���A;��E'��5��C�����;�ٌ� {���;��ؑ��¾����(��_������<����O�B�>
w��s�G��Q��J}>t'�?xK�7���n�vl����S���/��w'�?������߻�;����c������|+����b�}?��X?�]/�'�;a���?X���A;���WW�# ;����b�w����{���3���ax�t���o���������//:����K��+l�iE#<�����3��m���}�Ƣ��GN.s�K}|Zm��ruO£���� (|]/��>�P�t���2m&��M��"��*�Zf ���#	�
�n��n(%1�����(���(O�8��/�Gsu��fw2T2p�
�)r?�G��Q6��^P
.n$��'|�g4c����t�2����bQ��r\���� M$�"�Hk~�q�D�՗z-hN�@�l�4��%�]+^�e׫��ӝ�����b{��6h��_ך�cd������������(����;�����a�l�t�@Q113gq���b����z;c����kC:�gs9��نM�q�����Mw�Q���ѽ����פ�{:�yV;���B�uR��4S��؀(:�q�W�K��T�B ��d\k4�~@(�ћU��C�#��D�^cК�ñ>*��a줂s
���,9@�?{g֤��E�w~E��2� ���
��K������[k����[SWrNT�/����2R�\��>����(/M7� ��v�͢����ݹ>�{V�S�f���l0������{zS�?p����O��������?����K��g�Ɂ�k,�_������FhD�aU[�����~����{{`��a��a��7��"�N��������$:�8&c����$�r*r*�蘹���4��\�#����#h�8��W�
��W����3�غ�*M�-b�!=ns.����Ul��wm�[����w�S�Eܞ],�\�W&T/{��f@,�Ò���RH�bp�)����'�vb.��U�>�^��*���6_��U�����?�>�H��j����MU� �4q������?��������f�b�q������������?�|cES�����,��&��o����o��F{���/���L�1߸��}�8�?�j�/�7B���d���
�?Jp���+��ߍ���ď�o�S�W}�bk�4��4۔ŏλ��b�V���?���n�6��zTh��i�������\k�Z���&f�w�>������ W�v'��={YNuZV��er8���:>v�x��]�Rl1�¸^�������U��f�G�NW���]��:�W(������}S��wW.��69V�P�v��ɲ){6i[۶B�ԣ�D��FmS��!=��BS��_��k�1�J>�v��\�A �T�ЭN̬�q�fC�+Lx}�ˊ{�@�c�v��V������ތ�GC����=ǒ�B��ҵ��}�R���_�@\�A��W���C�� ������?���?����h����������?�������N�=_���,���`��U�G��m[�mNyy�a�J�=�SN�[Q�K�z�L�����CcAF��wV^sb?������U���M͟�a�&oy��]O����/��c��w`e�.��ߺ���ͭ�$��6y�{�)�7�B�>����<p�}�d.ʀR�X_
���f^��c���$/;����?���T4S��1��?���A���Wt4����8�X�A����������?/�?��4��?�O�㛢~��k���?��9���������O��	����7���Ԁ���#��y���	�?"�����/���o|�VQД������ ����������CP�A0 b������ga���?�D������?������?�lF���]�a����@�C#`���/�>����g9�I�y��j�o������Ɵ�ߘ�Yg6�Z�9�=��E���?���?7�sP���uRt�Y|����Qg��=Ic�'���9���L�WlG�/C"2F�����+�SS[ӣC���؜�vՒ.Z���:��r�l��e���_x���n�?{|U�༿����^.d��T:�)�lev�o􏇛w0��`u*�,%mڦp���޸���Yh��V���@�TfQ�Ju��E8�Y�.��O�k�j�B ;�B����p�a���EZ:v�{����N9k�1f��E�=��W����g�&@\���ku�2��� ����?��y����p����r!��<�������҂(r\������H�S"˦�(�,˱�D�C��z����78�?s7�O�σ�o�/����{w��/C?��ww���V����Go���kylx�r��a��q���k�.f����|�XO��raˣ�,�^�PXeXus{<��6�z�
q����rLȋe�/'�Н�r�M�E$h�Z�_&��If_І5��X�����=�)�8f�����t4���� �;px���C���@������������G�a�8����t�����`��@������Ā�������D���#�������������������������B�!�����������Y�~��|���#�C�����g񽳷L����|�������8?|3���o&�����x�Hκ5y�d�,������,��v�����kf����<��Q��ڛ��Yk�V_�K5�/�l#]��za�aݕ?|����4��9ao�x3*zt6m��}�Ǫ�̔�N��J��e���Ч�XwO!-����G|�td���0'�5�5�4r��J��t��u8=�?�eMg�q����C�<��c�ʲN�ۡ���-��۪pݒ���[��s|2Z7g>-M]����'��	���p����ux��e��9*]�����+�\����'�1e�6�P%�ߥP:V����ݒ>��j��2�_O����۹���0^��}梕3�mv4��O]%ծ�ږ��X�;��=��Nn�e �SA7�u��U.��r-%��$�N_妄k[��l��q��M��s�dI!F��z���)�Ͽ���n��� ���?��@���]������\�_"i:�*ɲ4�i6ʙ,⥘�D�ᓄgi�Is>�$��h>gE�f�$Ob*�3	�?~��?��+�?r������ق8��Ó8��"��0��?�#�%^?�Xc�T����vgmUI�I��[uƺ�N8/����T�>�}��Z��|(��,����v����A{{���)j������?�����������	p���W�?0��o������q����3��@�� ���/t4������(�����#���Bb���/Ā���#��i�������=���+�4 7GS�����M��r1�]6;���,��4`�����{��.�t���S���-q�8�NG��� ����k��Y͜��l�|�媥�e�L�j�V]�?O�۸c�u�u��t[�6��Q�ߎ׬������֦��҃�b��]���%������%	�����<��ԙ�'b������XS���cY2]�J�EκQJ���D��FY���{�ӝc���3�H���2aG�2Vμ�o���?��q��_�����?,�򿐁����G��U�C��o�o������1���E6����?�~`�$������=]�[��7��닾#�K݅�@!	�����q�&U	�l���f"�YA��Q�P�0�+kL/��sZ���VFӓ>`]k�O������<ߢK���/E�z[Y�i�����z�YAMe��ц��{ɫ#���_=YU4y���n�9vM����滍��F���@����t���j;>����y�/S��Ү#�^�����V,�5iC�[��k�����ߥQ�E��_�@\�A�b��������/d`���/�>����g9�������[����N�/����[�4_Z�|�J��P����ǿ���B~��~�{뤐O_���W=~w��RYZ�rf�cW��M&,����epȧ[�= ��<���p��m
R������u�F֯���j�դL��u�:EX(������www����>�����^.d��T:��.��Z�C�#�j�g���A<�fd��z3�L%�)��A�U39u�8`�׉�{��ӎL�eSs;}�Cw'R��6���f���3�0ҋv93�����˼\�uN�Y�2g!"[ӽ�:�Y���Cnݪ�K.�-J-�Jte�T�6��������/d �� �1���w����C�:p��J*O�!9��DLQ���(��Ȍ�D&�IA��/�|D�t��#�<$�~��U��5¯��*֫�-�Ex�egA����=�q)�g��9�vZ�s���ݩ5�)�t�[c����h��kӉ��n��t�
W�����8�Ƴ�$_)��z���vijb8럒�<2��Y���������X����ߍ����D`����3�����5�/O�O��w#4�����-M����S��&��o����o����?��ެ�cy6�82Ϥ8�2!%�OҜ�R*�RV�9I�96!91a8�g(!�.��4�S>���������� ��~e���7�s�+I��1��C?v:�m���V�o�y<���K���^ר:U����[��b�i����+Z�2;�X�{tN72����e�î���W�b�u5��ϳ��YQբ�F{�����}���0��o����� li���L������!���?�|�
�?�?j����? �����Ɗ���G�Y8�� ��!��ў�����_#4S�A�7�������?��Y�ۏ8��W��,��	`��a��Ѯ���7*��� �W���������Ѵ�C /���o����?����p�+*�������^�����ρ�o��&_��3��MД�����j@�A���?�<� ����6#�����/�������XDAS������5������������A����}�X�?���D���#��������������_P�!��`c0b�������������C.8p����9��n����o����o�����/p�c# ��Vٵ:��D������P/����7.��E�Ȥigy�ё�K��e\,r'�	�1�$l������Yl&�+�b���������O=� ��	�������ο-�����<ה��4+:YG�ހeͥ��?���KM5۾�+rF?zFs��p���E���*"X����*٩D;UI'@���CFI��r2�֚��m_�1�������'L���PMS�͆kx\�Ƴ�y�N&w8s6��)[!�O8���N�"�J���IFc�B8�+G�͘zC�W����s����l��u�(ge@���6��Iu���}���������y���C����u�^�?����?������w�� ��3��A�O�C����`�����0��?���@��������������z����w��?6���?��������:� ��c ����_/��t������9�F�?ARw�Oa����7�?.��(�t]�e���%8��lPh�����+������?���d�z�-�}�yH'ߐ$q�����I�ܡ�`�RMCg��f�2�]�C��M�G����o�M���������+�d�jԹx�v��}9jJBõmmأ5��@�V�j^��.s)l���-G�K�yJ�,��IK�`����Z˴�<wrC�|�b��oc�߅^�?���:� ��c ����_��t���)H�L�8�tS���d�`C?"���A�=!<4�#*�ɡ��(���5��A�Gw���Ȣ�w��=�xr�,��[����r�Y��:��v���z�9���N��N��`ڰz�a�բ�a!#���qw�-��=�ܠ��(h�"���`���0c��m0�FSߵ���4\�����?���0:|O��?��G��k���>���?J������?��_y�I� ����������V���?�0"�CT8�� �I$1N{�0�j��>u5}�L�̐@F��nD���A����������V�;��:��,���Q��܆J���9��ĥ�V��M���͗�GC�Oəݮw�zd���V��L����\�P��/�ZOp(���H�P�S%"���g~(�-9oRr�_T)/5����������-���\�E[�������hp��
���҄[�W�u�k���yrS3�ԉITw�_n���Fk~�������*���j��~��KrN�[��_��z���������疵��M���)�O��vqI�n�}��S9�y[@���+���ƽ���� �u�eT�Uy�sIn�pܤYG���e���p��_ua#4��,n�c�.��va�ϳ_:!N=�J|�Ob	[�sM��~p��3��J֦J:��5D��?a_{�RI�t�b6M(T�p��S����lA��!C5WeR܆�A�,v�ލg�k��LR�Wd�(�K<H�����[��_8��	����^��������?��/ ������wwh��_ր��ޠ-����~w�C`���u�3����W�?V�v�n����#!��X���������~��O�H엙�ї���������R���R�Q��ў�
�5�@��r�euQ�X�2�`�S�p�D�����tk�D4w�)b����e˜�K���
�]����KQx��|㣾��a3�Uo���/2i�\�ev2+k���Щ����r��k+R~���3Yf3{�kds�v��a��|Є�*��D�3�-"<�]c�#[7�T�t-!4Ϩ<_�<�l�RsF$e�w�I �K���bcFL$V��s�/p������o��������?��/��������wh���C�~�So*���E�?B>����m����7�o�/���>8Hx�e^���j��M�?����^�w�.�F���9mw�|�w{5ڟn^�]7�k[��-�GxGޭ<�� �/�~!a,�d�"�lh�6~�}7Ȕ>U����:�/����.o���|�6��"�DKی T�3+㾴i|ɶ���s�<��/�>2�8G���Q7PÝ��� M�%�cvD��*�|1Ȏ�y��s�g?}5���/�	{��茟��+��aTqw���*]��4�甴���"�Td���� <槈�<��ոL�5��{36u��ftI~�����@�oG�T���9�����	�6�V�����0��{���MR��0�R� w�N�?����pwQ��?����pw�;����8���!�Fc~k-�0�K{ad$M��G�;��4G��Z��̞1"F��	�{1���h�U�*�U����Q����O�A�sy�H���-v�.3&�OeZQ2��xS*���?LX�ݴ�Q��|�$s��-Oɸ�<L^��e�C�TCȦ#�>FO��ȥ+Xu���ȯr��I
�BB�1W����1��E(��_���{�@�����_`���՝�{���ZA���~��>�?�zP�E��ko���V�MX�e��؛F�*��]M7Э��5`�u+7$��UY�`�3u`�|�~c�5BA�˗�l �>�M4[��'s�amK��7.z`���F��-�e�PFp��Q�e�:�Vg̟���J�$2�w�7̺�N������ѵ�}c��:��oW�`��io��*AF��q�4[X��(�c�����xw�73���Q'Z5u�B�<K��$)�{xF��#Ȭ ��F� ��~��_@�w+�J����A�=��	���
@���O7����t�N���s�A��������?��4��z�3˧�(��B��A.�˙ƴ<�ݺ$�7<���`7-��_|ݝB���|��ʜ��k�w�$/��9����s�~��Q�j��%U��1$��J�k�6�s��.���;�1>�@�N�A]F|�Mԝ��e�00r��ł���f�����%^-�r��O���LJit��]���FM��)��<����������=���#�q����?� ��c�>�?����w�v�T���>�P�����?���?���G�_I��������ۗ��Y�;������'���A/�������h����>�;BO �����!���/��t��`'\? �������������E����\�������
@���@�����?�m�?�� ��c�^�?� ���ZA���� ��c�?������?����M�f����?������?��t��w��s����?����m�-�?���`�j���ݣ[�$��H�`5Vf����[���������ϙf܈s%t��ܻ�9A_�dY����'�:�2L��=7"k�S����$��:���e��2�+�@�\�l9'���މh��S�>/v���,�9�<X�4*v���ͥ(�[�^�qR_�qb3�U��K�Y��2;��5��c�To��e9��5
�)?�[ƙ,��=�5�9D������UE���y�E���4�k�sc�&#�ʖ�%d����+��ՂMYj����N=	$]`�2�BVl̈�$�*~0w{��E���[��C係��VЕ�ˣsU���n����}����?���t��Q�Db��P1��8�\*B��~4GC$0�j� "������~l?���8���?	�x����ĺ��O��|����jE�%os�x��]O��M�ԗh��J\��A�Tu�Ц)傹7som���G�a�عX��Z�O������f�w��T:!hOQ��e�4��-X��g|�E������Is������r��h_m�ݓ����p�G�;���-�O���@���h����������^�?M��?��h�������@�
���w���`��ZA��B�:�����?q���?[B_�t�v����g�?QP�i�����O���m���_P�k��?�9��������?��@ ���^�?������A����@���O ������� ��t��@T� ��c�^�?q���?������G�I@���r>��������V������R&�jx�����	L�ٿ��%���7���[;iO���[�l�{
��j�����g����A`�@�V���	'M�ds�9%�p8S���l"#��+xa�aD���s4gsmն4JWr�7�^�k~��8�}�61�t)�T��FH�-��f�9V��Nn]	Э�?�u��D_I��q��!�y���/M�zu����8^o�v���C���?��;���>�V#\��顊�j[R�1�	-�:ﵺzbSV���Lp��a4`!yGL��9&��`W����\����?B/�B��ώЩ�!P���������8� �����~��xDz^�Q��C��*F�1IE>I2>�h|�!CQ
� �)&���d<����?��>����O�0�˳)�����#d;�|����S����<Kms��s��"8��x3-3Je�.���$.\n���9��	)�̖c?���LN��3Lߤv�˯1qj�G�N���U|<�O��{?��OI=z~������7>�(M~w��a48�k���Ow��Uk��'�֟�ݧ8=T���p(��iHw�'o��te����BUT�W{��Hv���f�����Paw&����L���Uv�����˯r�Q/?"4���*�Ue����Zi>� J�����!	QVD�6��K�~ �	i��Pew�ݯ����C�OK���޺u�<�=���]m���vd��"�x8�L�jJ`�g�*pww��Q�H�T�r_�_"p>���I,�;/�D>��y3��jp�
M^
:xyge| P��w�
"��q��a�;�~/�:��vێ�Ȯ>�/�ѝa$?s�aOSmY�Dd�D���"�;��|^��hvd8�m�6"=y�ڧ�GL�km�:�Q$�\���8'�
,]���ٓ���q��hJǉ<��I�/��i��ȡ�`��:�mk�=�cД��Fv�
G߫�4w�T!��W���������������\�wc�H�u��{�@�����N�մa����E�� #�r̻N�I�GSq4�U"��>~�f��d9_Mc+�;�i@��cڧ"x�kt���'�>�n��wڽ`̡,�	zwN0~��x�t�b������`4����0��D`6��� ����o�߾���?���~`�Ҋ%^xNk
��*�*Z2�d�������HJ�
�%����.+mTW�m,������i,��"��0���<��������_��������~����p_�^?��<8�)T�>.��3��zچ.���B����/�l�����4�}�!\��qP���s��;��t�ܡ~�ag\\H�]��n]����k烺��C3���t%���*�8MV������Y����~���/_�ϧ?����������ק�B��ع<��˷��G��ٚgzK��y����=?"�Il��?����ȥ�������k���D�O�����~�q����5���/�7D0�:w�\�+���PW\i�(\�6�^İD[W��(턊fR�
�rJ����J&`����	$��R
�� p����	-� qX�ځ���/�_���w���o��������ɥ��K�������[��x�[7��<A���&���2���۟|\/�9�g��}���{��<x;��Wm�哈�3FyOU�� �m*���
����9o����\f֚��#��k8�����;J��Lf�P�YKD�a��(�We�����2����$�i��>I�L�zr�5Q����:KԖ�<e�"��ݚ5�%7�V{N�XBY6��m�G��Ưp�)['#��q~�o�d��$<�����ɾ$�T��s�,g�F?ϏK��r����{�N���3$��}k��B&�x��J٫z:��$������>a�<�Zxk��΋4m�5���k�@_]�@O8F�Y���Ш�I�%9˳�PBK F�zk2��U}:0=�AK�h�7�
�)[��{���}��SD7i|�.5�&��[Tĩ��	a36/\��(xGYE'M�R��&e0�3��N�Bjm���u4́�\<�'�Q�����ЫO>D��v(U��*?���$���������%'����Vȯ]�l�����p��,��-!<����U�fB�U���)�#��s�+�� ���R%�Wz��i���Ħ^	FSn4Q#��M����֋�{�l���B��r/�iI��	d?����͐)H�<�r�E� �t6[��k̵���#@��x9m'�r�%���/4YBƏ"��;m�`�,-�|��Ʋ��4Sl�f�q��L�a6Z�\6U�r}9mzh�Y��k.����TK�'���˄Ŷ˥:��{y��#��ҁ�xP��;�,�cb����"�G��,kd[�6P���R�*1�&�X�}2�H�;OKĘ��e؞��D�U��g�z���e��r��rg:跙Gc��c%��cr,]��aY�I8o��ǘ��!�S�%?L�֘&8l�%��V`���dD/���ǹ�#$�R�����Yfs�!�����E�2�����~�%�u��`�rg��.�b��Wj�+ܷ�۷׵�T���.V�Am2z�w�G4f`�B;~C�9���Gz�6o
֓��NXObc����gش�ϰ	h�LO�cG���بq�og�Dy�V{9��|��O���hيFE�	�R���c�����]Ja�8o�u۳D�M�*��$uS��R�ɇ����D�G�c�l��L�uo0�5�U��N�'�FZv�s�#�	*w���wVZ	�'�q>�sx�h��a��d���۪�H�B*��zY8�w�4�4{e�v�q�@��ZՍ�&�Ĩ�2�yfje'�)VZ�Ԥ5������B\O�y�.��Ql{o)�?X���K���:�]>�o=�}9\��M�W-��������\Y[P�+���쯉�v���2�oW��߿���+����W�/^��p���wn~d�^I$�E��	��0�C���L��!V���p���1�����<����,)�4�����&/�X�K�[-�M�����Y�A���0��r^��t��~m8wea�+&�Z�i�A�/�>��zq�wc�N�I�b���7{��u5׃�Ŗx= ms�g��WNd��'��`�N��U��)���&�N_j�L����f��ݡ��gW�F��,�����buZ��(�4�q��M�E��mјۏ����-#?��9�ʊx����f�zOL�C�qib�!�OM쩩�4���\9mH��4JtC���������K�	[�@ө=�S��%�����WH�ݬ8hd���iQ�v��d�I�ua���c��U/ۜ�r�z3#�Y��rlc�4R�0���M,�kRrTM�M5�x�zA��5�J:���u��6�hm�@�i ���V�M9GT�g+D�/�qZ0I��,7�6Q��;fb�G5���0��	&v;�%�^�EX�t��3�����hk,G�l�_E��19�ϣ�On��54��u{����V��[�7nA_�u��[U1��'6�OlN�8�_����K��>s��%Yk�|��C��(�@�4yD[}] ��V{���dK�``�Nz��d%J��1�Pn!��,Z���)�E%U�9�67�)�Q�_��A���n㔩�g`�lVj̥D�4�	)���d ���v��cy?��)�
��&{�'��g���Mjd�aP<'̦.ߍVF<[�5[I�$�1Jݦ�qT0oUu;��U��x`���Q�����adY���2ê���դ��9�2�&���/�6q�M�c����sl�U�
�x�~ƼU���&zx������7�z��Ջ��_�8Օ�8�2ކ>�u�^�2^��^��7�����r����ʣ�+��{MN�FCSY�H����\	s5�{��ՠk�E������K�<R:�9נg��[����߁oܿY����`�5g<�~z
| A����tg�`׏d�������l�5�}r�8����y<C�����3�e��i��Hu\�pǴ�g8R�A�������Z�M�#y�?��E�q@�����
=���\U���i�<�n��w���_a<����6��l`��6��l�g��� @ � 