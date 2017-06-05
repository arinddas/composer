ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

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

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f || echo 'All removed'

# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh

# Start all Docker containers.
docker-compose -p composer -f docker-compose-playground.yml up -d

# Wait for playground to start
sleep 5

# Pull the latest Docker images from Docker Hub.
##docker-compose pull
##docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Start all Docker containers.
##docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
##sleep 10

# Create the channel on peer0.
##docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
##docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
##docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
##docker exec peer1 peer channel join -b mychannel.block

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

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �h5Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[���1HB�u��	7�'��ʍ��4��|
�4M�(M"�w���(JbNR��1�R#?�9����vZ�}Y��v��\��(�G�O|?�������4^f2".�?E�d%�2��oS�_�C��_�,��w���叒$]ɿ\(����⊽u4\.��9�%���}��S���p��)�*���k��O'^���r�I�8
�"�;y?��{4�b(Ѕ�;�ԞG���럕{-�����4B�����yNٔK�(M�(M�Iظ�E����OS$����Q����O�7�g��
?G�?��xQ��$�X���g�/5��������ؐ՚�}P��	���S�4]h�(�H��&��I����V���l5�M[�Ta&��~ʧ1�<�j���@.6�&h!�S�J�MJO��<�Mt��h�C����@O�{<e��t�����24H���ֶޗ�.��P�Ȗ(z9�����tj��
/=���ѿ)~i��^4]�~���c������R�Q�˸:��N���=^��(�cO�� V��<�����$�ڼ����7�n7�́P֔��'���e�ϚKq�"Zhsa���gݞ�	`ƅ����Y��i1o���h(ō :yNik�����֍��2ġ�i�<n��L���xYCrf�ԙsu0�O�m�w���q'�ǅ������b<j����)1�C�Aɕ��`!��C.��z�O�-A�(`~n�D�MSى�C�C�����������N���9�5�țr7�6�8Xs�*���f�b.�~�|������[K���
�4���6A(�(:�)( 2�T_#Bi���Ю/滑D���H���`��Ɗ�Q+S��_vЦ�6��0�Y�%C��#�w��f��9�[ݙ��\����� �������k�Q���N}��=/�����V�x.,)@�@�����u���(��EƤ����7+&@fK��(�t isy�1����R��(y��@����u��@.|[$�%���1�e�����}v�7��k�r�-'iKj����Ũ��,��Ez ǢϙE/�f�\�}X|`6<���,����i����D�������(���*��O�C)���2���������u�����Nݯv�zK qO��|h��x,fȑ8N�
��Q/!T�G��vB>$��N=��"��U�TA������^���i�$��h�o``a���x6ad1Ok�K��w��Dѭ\������5$B}ٚ8������ˇ��B�7�<6]�+�<s�y�i��}߁��{o��]~�-C��e[�*�ቪ{@k�(̶p-�#��4M93rր�6�����C�� �v~�d��Z.� ����>kr���r�Mwp�x/��-��))�D"�a�t�zr�a�:D��K}0�m�`B2���q���D���ϛX��X��P���o�m������}?��Z2��h�Y�!���:��x��_�������$U�����Ϝ�/����+�/��_�����������x9�(�T�_~I���S�������~}��>E8�b�P6[\� �H���0M���H@�.���Ca��(����U�?ʐ�+�ߏ�(����2pA�����IA+G�	�2�x���
� 4.�7�|x1�g-[�m[����r�45~��Ko�R��d3D��/9��g�A�ۑ���s���W����v+�j� �n���iX����4�?3����/%����+�_���j��Z����ޥ�?3����R�A����?��W��3����̡�H�>BaJo�vZ��?������|��,a��Y�c�gb>4����m����T8.Wy �Ȥ���L꽩4��s�m��{�;�9TD:FwE�z�ӹ��6֛ɼa�]c~��@�t��ʝ��1v���k̑��#�r68F$�{�����[�i��1K �L�0$�@ ��6PĖ �!/X��k�N8a7E�j�de:�� �n��;���GӞ=4�*���TQ��w{�χf=�/��$d�����f�u��LiYZw4�C^nvL5QBډI�H�,E�vC2�	\��d�Ѓ������%����?D��e�C���?�����������s�7��~�`��?�`���K��
Ϳ�����U�)��������\������=���Qť��+���ؤ�N?�0P>���v�����.�"K�$�"��"B�,J�$I�U���2�y�BShe�����T&��j�R��͉�1]0��cϑV�f?h�CO^��(���0�;uZI��!��h;��e>^�0�m�F9fl������#Bݞ��� ��|�q��g��Rrj��U��������~����(MT���������S�߱�CU������2�p��q��)x��$޾|Y9\.'�J�e�#���vЋ口Z��-����������O�����]��,F,�8�M��M��b��b������,����,��h�PTʐ���?8r<��Z��|\���Et�RKD�D�ń���6�F��w9W���i�~�~q�g5�	^�뺻�V��KQ=�#r�1v��2��-ptˇ`�Oe��4v��U뙈k���6H0{0��j��������v�w�]���w��P�xj�Q^�e������K��*��2��������o����2�Z�W���������]���X��a���ǳ�>�Y@���g�ݏ��{P����]P�z�F��=tw��ρnX�΁���~�9�Ѓ��6��2q�p��N�}1/�.���G��&1]���&�����k��4�Gx,�3��gr�CMf=Q'���7G����Q[x+.�K����Dӭ3�YO>�#ܖ�Q�2��8��n�u_;ms.���k ��ݚ�r.k)ZV�y:E��ڔ�9��t��nw�cC��B�w{�C ����䶷�<����à�bM p"�r65�y{WW\����Vd���Fg9�,3�V�֟��A��߃ j�;%6�NГr�&{+~f��ni���p�5��!��x����/m�����_
~��(����[�9�����[���j�?��I�Tu�{)x�������q`�~��[����NS!�����������䙡��7P���F���>���my�@M�wM��-���� �B$�vr��))�ci�J�hl�F�˶���[��SS�m�ߚ���&4�T6c��ij]�r�
��H��'}5i�v��@���q6��K����>@ k��#'P#�ڬ��]z�M��J̳F��K]��O�\;|�՞ق%w��Z�o�~�;�F�&����-T�}z�x�ϳ���#��K�A\n�#4U�������'��T�J�g��j����2�������V���Z�������j�����]��\l�cV}�s9�\��[w�?F!t�Y
*������?�����z��S}�[)���	��i�P��"Y�eh��(�	�	� �]�}�pȀ�� �}�r]�q�N���P��_��~t��T�?����?@i��-'�}˜�1lv�C���s�`�����GڢEM^��c�9��v�u%���Qt/YS\��A@����X�%5�Zߺ�#j��������pF�ehr��Lo�W�(�M{h^��y/�؝�i1��$���}���{�|��8BPO�!��j�����f���Z���2?�N]?�
�j��/��4�C�km�O�t�{a1�I��k�1�E\���5re/��}����N�x�����Z��&N���4�����.��Z�������8]g���������Ҋ��K�k-�Ԯ��_O�Ż�])��Պ`��k����yh�:����e�|��y�+�v�`���;���]y�.�ƋM�?�k��Sݾ��)n�{���K?�Y�Q1*\��2�(pk+܎����r_V��.[]]uQ�i�����MG��
A��o���ߋ��׾�WD���e�ZQI��`�;j���y�av}�(�΢г/7�˃����·��śWK���Q��l/V`t�7E�p�xV{����ǒ�LZ�����q��q����N��+��o?�M�v�����U������g�����@.*�=,��SS�8�O��7M���8Y�a���	��.Nד�s]��L�GR��j�h�B"GE��H	����}7@�ȿ?���Y����?V��Wtñ�E��������w�F���Y��{�@�Uő�m�n��ɦR��וU��f9�}�axgkxk�p�Y�gK�:{8�O��?{��u�m�^�����F��&�i�z���DQ��fSu���2�F�횢(�EjH���i��@
�(�� -��FS�}j���Eۗ6m`A�.��ih�����H#i4���u�<3�����?���9�4�[(��՛��M�3��P&�3��&P�J�C�>|H&B��6��̆T����d&ݾ�L��4�m^9F�:�Iȁ���`[��7���H�i�b��� �� M�EtH�)����C΂�1�H���x�"��܅��������j��\
'��}�PqY�#�P0�T� �\p���ପ��xd��4��Bބܨn,� �P��Fd��}����@�3��d�<e!�O�c��F
��2_aۢvB���9T	\Bm0��Лu#+���8b	�I��?H􆜇��Ծ>)�'��%�P����Fϣ̷x��ކ�Y9S�2Д����'Mga��M��8�ǁӹ�,8���xpꙂS���:O��C=�ͩw�l|}�����-��W�-�g��U���x�����1��c�J:���݁$��D�8d���7�F�c>��R�9��ۊ�&ª��	
HS�<7�~Cm��Ӽv��̫�"�P�0��dxH��w�P4O��F�b�3��+f��c�
�a�7���Q�p�d]?�lV�Z��ϳ���
��� u�?A4E3���7|;���ڊ��]UZ�ӌ��w�q�xwk� P�aO�6��STP:�ADc����7:�AX.d�moSd�0.[i��k󪶓���}�0����@֞���^��Z�\���E�/��~�N���)|f%@_N>u�!*�aE����?�o+��U�\��Nq)h�����:x�����=�0o��~�?��b�.��2,���v<�Ř��c�����4^�Xq3��6���o|���0�����{
��K��p�������I����*e�+Q�4������k����p��O����C������	�^���^b� <W�q[P��r�
j�d\�r�ǩx�ø]�I��:lC|�2th��mP��v��%\�p�.��p[B�]���P�dU��6�R���9
�R�uv�JU�U��z�m|XxJTx��7J]�ɗ�����f�	&���xǫ,ʲ�?������ְO*�F���=�	�p�In�]�e���I�Un+��.��se�_YP�Z����L�v&���7����Wm��+x�[�O�̖ۢ��⁔���0C��؏���0`y������L�%�v8D�������3	��?�a���*�iN �?I8F����:��L���?��6&#pIj5��v�("�%��=&x�68|c������������XK;	,=�;^k�6���0C�����X ����=h�#�������wxQn!�\��>>�s�+����A�>ZPd���Vؒ�:͵� Q��4Y��j�H4s;HG��7ނ������E�t[������wƈ�^EE*�M|}�_�c�8���L4�X���o]GE���\0I�*ޖT^{gU��D}6 }y���n.��}��	SD+)W/O~����ʛ�R��mcW��RO��*;��_Qy�Ye�թ*LľA��u@K"
��/�t�o�Z��{����߼�_���/��u�R��:��5�ťv��+6��+������/�6YPу:A`4��%7di�n;���6�E�g������y,���������}X��:���������e��[�g���'Y^���}d�����t�����E������h�%8+���"+��-E�Z2����F�u�s��g>l[��gjm���n��A�j��7�jM�Kf!��U���i(����;�!���O��#9�$iG���,
/��q�����p��ђ���T�O$��m�!��ت���j�lG34C�A� #g1{����>�jQ$��:ǈw��G�r��\�\�sN�U�O�(�H�=^�9�;�C������E�����a٦�=�}U�8���c����!�
����p���I�X�@���W�R��d�0�A�oOZo����5�։'��د�v�2������9�g�SRB���Qx�����������:��l��_��-����u�=f�v�k�e�6~P����L�t�v�2lH��xi4-���l�נp�m�P�DVA9��o-᳍�w�*�|k�WX����;��;���^4S��{<7|5<RdD8\"��e|b�:��ܱ��u��&ن�C�ْ#sԂc�ZX�:��^���8l&���&j�Փ�N��L��'ph5'
O,,<q��C��ذol���Q�ߔ�c䱔��D�?�����>,���{�<t���$	���.���B�����?�$����_y�⹕������1�f_{�DT�*�rT6	6�M�(�Io��%������M��*y*d��yʄ����#9��c8x�ޅ]�����O��9��\%������¯����_��/c?���b`?Ӌ_�aa��bl�~�" ���b�x�O^ �B�｀����_�����.�����*-/5�kթ�B���y�]�n0����Fj\��r]��2�F7�.���U'�թ���D H�(�/2~&��̧��yx>:;�rD)̗���m�Pi�;��Z�^�;��������@/r:9o>,o�҃��R�<�+�ݝ�ϓ�z�Jh��4�9җ����Q=�t��ۻ�(C��K|T
V3�_����w�P �6ڝ=У�����T쑮���4�e�>=�h7���YjD<�0c��
9�C���@�Pf��~��i�m��PB�-��z6׍U��\M.�Aq�"U�դ��h�!�^M�[�P͊�l.�o��1e�eO����`�
����.���uκ	˺	˺	�(7aa�Z��� B�ءK�4C�F��9�����
���l� U�b~dݪ9{�c�HZhe�N�b�
�'73I��6KE���=5N���52�'wr!��y�F�ʨ��H�j:�m8�\B"XYC�A;�&��m{J��A"��3�Or�	�� ��5�L!+���C}���U���]	�m��
�J�P��C�mO����M	4Z�T+͕ۍ�t�J���יR"��y1�IQ�z�������e���%{f�rf�v:�P5T܍{�8%&�A��L48{:�T�\� �'E蜿�XBꕃ9�Wؖj͘?��lY�c;�V����r�B�D&��X����cƓ�QIܞb���s�%������#ӞA(�v�(#�YysG���v8"g]t���(Bg���R�q�EZdϿE��X2,x��f����+I�'����J+@U�/�Dg1Ko��g���%BF�|*FP[e.G�BN/��X�O���3Ym��N)�s۽�4�KT~��6�jE
��ގ���6���H'MD�� r¹�е� F�a�M*�E$��Զ#�)r)b�YO��e�Tp��x||w�U�S�U�v���2݂Wh�@uǝM8��U������	${jSᴀ���uנ�&kl1L�NW��n�c���Y:���Mg�x�B�f�6<�W�WT�셕����
v�d塋Oa��J��\�x®a8���X�U��8��g���V�%������ո:�Nnk�3���1���TM���S����'��ǞŞOSǷ4J�//��m
i^�A_{S������7����l��c��9�*��IbO���v~����w�＃�մ��s{j�S�^}Ĥ���#�n���^r�ؓ��	�;��3�ͤ1^�ӌzq^:�w���T��b��{W��cȰ���}�H@���
:<[�l� �c��}����3��k^�A�������U�'����gM
�I��'�.�#h�撣�;�H�@��)w|y`3'ѝ-�Vveu����LJ��p��ݭ�΀�20#�Q?K9C*�/¡�����yƟ�=&����t�v��:[H�Kc��1&;��Gg��l�l �����*�`�&� Y��:��\f��]��;Ƞt|����4��Q���i�kL �n��h�&"�'見���AlMl�
!��b�-_�7;dj���D�;Hq"$ �w7C����W;"����n��A�6Yg�*���2C�tV�ဿU���6�d`�����Fϔ�#�	1�>dwc#�	D�hBU���@��g"�=_�Q��vB�F���<i>��;�� 帷5pK-�&S,�"$��sd�u�3�5���: ۛ|/֍V�RM�
�%G�����>�|�2p����qIP�t��*6K8,ᰄc���ג^�>��ώ)��>d(&�1F:�c�fw{>7�I�a_�iX΅�s�'o�����~�p�y&�eI��XҎ:�dƌ#lc�.'�b�R�d*R��پo��*��qd��@��\T�S<8�Q��0��l"�F�Q���(2^�1�ꍏ�Q�r�&�!)��J�jۭ�x-�}8�M5m[�ɱI��V����k�H��UA���썠s�ڔ,wt���D���m��E�t$?n9h�C�m!�|����l����a��m�Zĵ���d,��!"�D��$�����i��Hػ�bMs���X�Wq��e*���|qvس��e#^{
"LyK��J{Nz �["e�q r��j����;I�!�wCU�T4,K8,�xЄc)��9i�;�R�\Z)��q�בLrG0�]\��f� ��V�	R5�)mNk+��p��`xz�|հhR�«*��V{<9�>j�_�F��X�ajM�V��L�r�=�m<R��<eGEE���(�����ӳ�_������=�����������K�������/`O�BUb������nV�K�μ���<������:��l�]Ŀ����[L���ӿ�%��oƟ}��������?
���G�?��o���Ł<��0�����}Eϣ]W�u�B��]�q�����~���g޲�����?�����o`?��c�?ǰs����hҵ�k���i�vZn�����i��~�Wq-��e��\;-�N˵���,����ڹ�����^[©�(n�^p!�L���	�ɫ��f9��"��c��[O�1t���?p���+؇c�	�c�����Y~�R���j�X�a	�}�38���1���T�>�f3OӲ��X�Vkό�-��`홱���3�3s�����s;s��?{Wڜ:�e��~㚈�h�־9�M��;����ʎ@����#��`���YR��x6N��"����r�g�]1���e�_�x�'.��Y�K��߶� �����"�����?Q�����I"���$N`�gJ|`M�S�b�BPP���C��� ��Q~���?#<�o���48P�~w��^Ԛ��Y�q&}x�*�7r���3n|$&$n°�~�}���̿�|�V�;u������sY�w�nu��;����ֻ�1�>hd��{��(��k������A�Ck�b���ᬦk����(���������,IRʓ3
T���_�ß3��@�<Ȃ�5^L��<��5{=s��B�6�d�s�^���������������i�����C_u1���;���O^�[�� ���SN,�u��T�M��	B]l4~ w�Wc�RC����#(���f�҅|�7��J�����\�7o$����黱I��7�83x��h�O~�dJ��]����7bV�R�7%�b�<5w��S��F��7�ud����}{{�i�J��s��z�Qʡ��v�b��A��D�����w���e�|;�I��)ؚ�pϚ)nvl����BN���NJ��jǁ/�0�C��	li�i�+�I�S��%yJρ���I��#z!���'f�ez/������*1����9��W�I�|�)�T`�4nY�4�v�qܖ�6#T+R��c1��a�[�/�ӝat�7��Ϊ��[�i?��K�c+�F�a�&�㝰D�]���rV�U�f�2=�_�5Wi4��S��+����^{�=�nKү�����R����!�޼�ub:��s��e�K":�7��7n>#�ӻC�y�	Ϝ�{�/��5[^p�c�n�;0M�T�F�t��t#k{��7��S�৒�n@3)�	��|t��wݙ��M�6:w�*��^�w7���g�[��E�{�+���m��P�e����{ O�a*���'����C1�A��� �v�T�CG5�	��*���!�k�xh����������s�����ƗA�0ݘS�y�-�×;XQ;6E_gS��7�^�Ĳ�k�vL��g��՛ �:��Rgt����St���iq�D����N��Ci|�����H� �?E�?Y����BW�?� 	�?
���?��sח?J�8(�(�u�힃4�/ܯ����|�Oɚ�J��;2.����_X�/~#(I��E)��[��E�s�}�ۖ���Q|u�?5���� /E���}g�H���9�����@��?2֎k���������������b��5L�5�u�J#��i��X�$\�X���TԠ)��4E�)RCQ� �'�*�7CT����_�I�����k$8�5%�B�K����bw�w*��\M%	�VN?=n,���]sޱ񚹬��]��2���i��u�
��X��P�q��@�Κ���%i�8j�kE'UD&����h��,�0�/�H��[�$�eg��At��4ސiI�2�1Q�=mB���h��+_#�N(����4v�����������`9��yB�������'��1���#i����϶Vŝ�	��P�����_ �@5�f\R͈�eF�$�(�������@��_pp����o�/	�������H����1�ؐ�����������bp��:y�'/�t��勫�z���K���(>}�7�k�ɳ���'�^����>�V;xui-gG��u�L��!��fˡk��_ΖCg��Jy �8O腮z5��p�"�C/���B�&o=r'q�V6���8����e��[��a��y������f���TG�dV�܀*^�V|���kR�:�,�~�^V��q^��zj3��YjpCEa6mH�q�f�$K�H��Fc�N��6�t����Y�(3��롔���Zd�H�ć��þ���I��P���"A���� �?Y ��������z����	��Q ���IA"�0���?�����w< 	����Q�(����o�/��?bC���?���������b�Ҡh'Q��MJa�ߪ�S$��W���@XĤq��4V�0�05�4Q���:���������q��_����c��5^�Scu�<uJzWhd-��m4n,��z���+5�ܲ�5�D�1'����d��>-������FVm�&�7i{��Bkn���#�0��\fe�ł��Tg����TR=���Y$����!���$�������ć��,J����?1�������� ����?���4 ��{�I�������p0������1������U
�%�@(L�]�C}������?���_���:ϯ�
^}(zM���i�L�2�(g2^��ү0<����� ;�Fz�+�^Ǵ�J�&�ڬ�I��>�iOի��%���+���4,.���Ï~;������E�Y�J��ט�m�;�p�"Iྏ3��U��(Sk�K^lnC$�8{;6 ���x�;S�EO��م���̳	m4X�q�U�K�j�u�me�����'d��@�&�^j*s~��NO�ch����-��bU+M��\��*�V��K�R�l��E�3q��:R�+gu���sYd����9C�
�o��D�?�������G� ���m�%����G|�����R�����0��������:�ה��w���a4��(���ć/m���O<�(�O��F �?
 ���������?�����_���_gR�5ECUCM� T��5C1QS�pV�5S�Q�a	�DX�QY�DH�Ei�$)�||9�(�w�K�A��"��e�W��|^����c��Ԙ
7\(����W�|S[o�Ҙ^��@	���<���e�zhf��dٷ���8�`�. �Gm�aͥ\Ԗ-��RE�R��f�!9�5[�A��;z��(٣V�!���4�d��lݰ_R��4��Ch��E��(�����������I��Q����_��w�����"���	$�������)��;&D��G����8� �?����C.�� �� V��A�������=���!����"�&������P,�j������c�N#�i���8K0��
˰
&�?������_�����Hp��o��k��ho&��Z���"fO8�Zy��%W\$������E<-���<����ldl�nt�3�In(l�4?q��D��L��5 1l	.��",�iG�kBY���SZC��?�$��z������O� ��;������D�?N�ǘ��?�v�E��(A�����?�����*��t~���Ε6�\��J�1M��
\���I[�@�Q��`��8KХU�l��N���`5y�]?����MU5O��7U�KmRk����⌬���n#��[��BV���~�Zj�09�]���M�ۄ�q�)�eO�ne�Do&tV��	�V'�\�zY.��=��} z�i��N�3+/��W+����Ė���<�Vr�ϋ����[�B�H�m��z��4=˛�]��u���'�%�C&���_�w[�(ߡX���3�^������V~V�K�㱺��;�"�e�Ns�	�DrJw�}-��y�^W>s�v�[�.o�6��Z��Q
w��j��)7�� [WJ��Mɴ
caT��7�����I.������r�	�"��AF�F4��Ҳ���Z�(貴�>:^F�:<%�ե1(�-��zƚ3���a%[m�dV�^�&�s~��jڝ��c'�8�s�������ņX�?pD� ��������׀�1����a�(���L���p�C$���K���X�0l��xo���R^&[�͙����e��(��'c�^�:0/t`��[�Z@y�S��&��8|�7΃����5��MZ�����.Ѭ�"r�vΩ:K��kt�Z����B�a�l���:�����k����ɨ�%3���Q���;zy ��σغ�е�����!Pw���,O���t��h�b7���9��|���zc@zR��Wš"t�9w��ߨBk���)D�GT�H�'k{�й���D"�?�����3�j��� b��������/���_� �&�cC"�0���?�����w����?8�z�'Q��Q 	�?J��� �?!����#�����)��� ����������`�a8�+.D��:��4��$J1*E�����Q$b8c�&Nk8�(��&kP&n�i��2N��JDQ������?`�}=�����B;�H�ͺ��-�]j�kt��-�x��Im\����4[�m墉U�x�����̥2U�Lb]�Wp��Q��cM/5Ak�_��U�N�{C�P͚dc(S�4�4�b�*��������6��w,P�-s06��G������(�ܶA�@�7p��#�/�	��)�*N�~I������)s`;nʰm��-5�S7���)��(Sݹ��M�K�'�[�L�/|��"��ajhA_p;�V�}-��Q���ݎ���V�A��J�RR�G����=
��􁝺�},IHS��?��+���-���k
��|ܸ�qs��	#�����o�����=u���7)?nϞi�0<�4eܷ��FH�&�G�߻ghJ�Xם��J�	NU:I#���S�6��q[���+��_�p��4�o݀������ӥ�M�9J�$����Vƍ��������,��&�sL�+~)�������ݵ�3���J`�ȍ�>\7fck����`��#���`��F��EԿ��U2������5�zϯ�{����T_qR�aLw�\O���r�F���lȽ�%z��S����q�}���vj韖i������c(�!`�'
\U�[z�:��?�#4��	�(�(���ߺ~a���4���ȃ��/C��$�����w�S��,{��k~���v�k}t�+��z��L��c��b$���{=[��B֓خ��힝���~�.���ӯ��t���Z����������rF2 E���C!�D">,�_���|@dK	�(B!�{�5Տ��l�T�VS]u��{ι�{�^mX4N�TA����m�����N��xL��OC:ϿQU��L0�� ���*<�WX���V��?���\W�ӝr���8_�=^"0o�}>�m������e������Ƶ�o��W�����f��~�A�<A����#��G�QD����A�'��S�w����VZ�P�I�� A�h/
�C��K��������_���+/�J����S��������������;i�ҍ���?�D��k��M�/#����ݗ7��%��������~	��K3���5�t7!����9/����emn42��mq�%;t.[�G�nj�-�F9����=��KV��H��[�.?�}���t�4��u����#��(��=�\��Q&�U<���&��FqZ��r�_%��uat����Ҋ�n,�Ԧo�ԭt�F;���SY�.�E�h�q�{�(�T��2<F�1:e[xr�H̸�-g�ډ�Q�(�Hx,r�i��Z;Z*�'�A��}Pk��9��c���(���*��L�-��j�}����vN�?E!MQ�(����Ń����G�4Ņ����o\�W��p{%|��p�Z�FZ���66��dȰ�):QQ���uR�z�&JvFH�z˺ߊ�x���d��2���-ҝ���\C��5�t7#�c)C���mo!�=�Ľm9��F���+�7�)���'V�qq�(D.gYㅩR(��^��0��ʉ�}L_��s�3��aE,+�$����;�ۯ�Q��"�F���3�x� ��S!V�l�D� H7�ޘ�M�t��υ��F.S�U.Y*��n4�WXbIX�+˾��}8�����Q&pL�i�N��\�Ƌ�ʴMTZ���,�|2V	+�i�"�q3Z��j|��W3鎛j�D��>���~#}9a!\�"ոt"���t6�*d���ex�LaI�>2�����4��L*�W)a�P
�p��H
e_,��vHB�ɴU;�'�qx���|���B�2���@*�ӭA�l�Z&,�%�2>_X�+Kқ1�4A�7�7�)��Kw&�77����T�6�!?�'�S)�'��A�&�ʹi�ޢ2=���)���!B�s9a�u�,��$H�WܫHޟ(���:] �ex�La)D�q�4bF��Ȏ��#��gG�rvT��i��9O�� Cw)0�=N<D�c�/�r��|ծo�I���� &9�/_Sz��e���l����V��6��p�miӋ<UY�%ԉ������������>���	�T�,�C�;�6���Xʬ��Xˬ?f���P�KU��Y�aJ�;p�MPd�9�)�I��ݗL�W�g"p���c�	�<��,I��@&9N{��2�|D�)IYuEWB�,U=O^R��d����5�	I�d��RSb��I�����[�"n��f6s�d�M�������{�q�6�l��^��ئJ9�)�i |��>�m&���
c��Yx�o�Bn����V�;���0���a�o� �� ��et�� ȓ0(�^�rи'�%h2��i����?ZG�m��=)�'+O
޾p��6˛�e�xd�-5��j8�W�c�}�~ya��C�x��H'k�#�t,V�uӱd�3�󰯆�����܆c���\u�1�*D�4�dY"6�.�� 3
�cr��/����4���Ƶ�_�Q�A(Aq{Coa/���K�^p�3D2J$�q�;ڋ��v.�ֈ�Go8��n6/�G�nmnfI�*�QM����m&8%�vޓzo�ϒ�=J�I�R9��BbQ"I�?SJN�C-w��MC�{/�RJ!�J���P�if����x;I�|��iw�ە�Jo{:�HS��ǌӣT;�w��x�+�H�v5$�'N��XY����J�Q1���*Ǧ��r��q��>��^A?��OY����k	�gZ�azv�E ����������kxX�=,���^5��������xXv$��N$m�A�d	�P��X3O�{�H��n�OMB�����3Vyr�U��zP��	�1�A�*D�Xɲh��:��n��C
b�uǙN4�&�D��$:�D��{�(Ď�t*ɺ;j#��`�{Q)��)� ���dH�ţ�H�ڱd���� ����B"�a��#���,u�g���o:�;$��\u(^f0����+���V�ȞD;���[~�I�!\�On�\��q9�`�6���q�M�Nn�#�C7�ݦ�T�&��0O���Q�}�֮+{X�r����M9.��xf#~+9e�K;e3%V}��[!̶��������L%)����,*���j�p����|]�h�ͦ�H#�=�<�gS���I���#%�� ���(��\+%I�?��+q啅8*$	������L7w13���ſ�`��΋o����{_��?�K����?�Y�:<ށRYuz�a����u��Oy$b[r�B�j@9���?��������|$���}���'����~x�����n��y���|�_��گ� ����@/�|=��N	"/�=���_���7`�8ݡX�m���f~���}�K���>�s������~�7~�k����i���?YR;���~0���};��N��S;�4;M�N��Wq?꫸v@�H۩�vj���i�l���QH��t��#��}���U�@���=���>#��^�j|��-���C�?������-�	�v�����y�R���j���a+Ǉ�gp��+d<�d��z���Y���͌m����?�?������V�G�������'0��˜�;w��ڪi�?��ч�����KM�!����G��B�gW`�]c��
)���D0@�������Gq��6�ai���&��@��]��E�?���D��q�1'��_mn݅(&����	�2�H��J���=3�&cy�X��{�c#`6�zt,.��H�!4d
��s �W�
�Q2 ��������E�ĺ��s��gR�X���y�U��ˊ���	FiK$@&G�0AĨ�Ȁw� 	��&	-yD�D�d�QC�g�e�Zm �xl�,a��&&K��DRM����2V%�E2WN�JX��E�h������8F掰t*���-P3����BN2M�m%��!�8X@04�bi�4��Pmk@�y�"l��}V�=*���YY;�i�]�"A�k�53�]���2�a��:��|7�@/[���ƻ�d}Ӓ�s�-c���3>,��GF-�i�3�5�E��Q$D:
JWA�3�@����R@��/����r0o�p�q.\bde�k%J�0I��W8N�Y?`�3Ox*��I���gb��:�[�6�;2��Iݦh�����m���6#g�'N�u80I�U�;�@�u1��U:*�c���yl�cW.�:2'}α���Z'1 !��-��@��j6#�N�q`d�P�\����p/��T߬^V9*��-h��%M�hY	����7, ħ*�z�
l�	� �t*�� }�;�ǡWxi�MrO4I+&J��|M���y,����~[�xj����_P"��ޤ��	�"m�_}.��޿y 
�.0'������-��x��K�NPtk	#�|����tD(�Ӭ�4���8l�is�ͦ�&@�8���"��@|���h�l:�~�`-�����P!��S�	]�A��t�PS	�::���婢 �ҁf�`ߘ�À�@S��(��L�&� ���miB(Mxz�X�{Z5<��VXi�@�-�SN�|�%`�%�`��;�eP�t;�9�2g�x�4L���7���1`��;���TI�v���y6z�M"�d@Ak��;4�tn����<�2��^[4w)[����eb1�G#������p�u�6
:D�:���VɁ�d�pu()?��X�8A���9~�๋��8�(P$`�ݻ��灍�k�.+�&��B�[��*�����*��Z/�Ϯ�"u�Ӹ`��q�lx��n���\8�k9���;�j����"M8�z]�^'g��Z�fI�.���#�5�_f����e�3[���j��:�:�L�R89��0��`�S�P�1=!�i�]`�N�P�W�ڥ�/+�Xǭ�Ү�d�up�.)�Oˠ��8�Y�-RA���2*�~FI����N�cxQ�88�����uR���6�q4]�|��G�;���l(,�,�/Q�k��:U4;fesš��{ Y]t�7�j#�S�;�/���hfehiGi���3:m����@/�8�rڄQ덹���
���g)�����.I����O��������j�b��O��EaM�UҒ�kS0&��Yoo�q:?�"�J���r�o��Jױ�h�->��w���c�na���Ő0�ǰM�"���ǽt\<[�� ��yՙ5Hg����iY��y�t�yEO�.�V�?���I	b�<	ʡ	�.@sD�9GX����S��Wl.8 Z�'�c�r9�Τq������W;#Luv��؜�it/'� T7f.�SM�w��W���F)V�1^�u������>���\v�׎��d����xw�1УKEq���abUu���Y��s#dD}��Dj��´�����l*`� ���X.�K�㪛�;�@���i`,���`������ ��	���@jD�S�����4(��33�y��t�r�à�	�%�;s����<����!����%�lc�p<�w�e� (�c7<�s0[��4�A58�b�p�4�B�@M"g��	�3��Y#�z-��3b�.\�T�j��@q:���!��mj�HxH3Mi����C��f}b��#��@��«
��0!<)]myC�{����p�p���hd�Q����9�Aq0d��B�p���]%�us8i��xeU�PNZ��V�:~�TÈe�r�`8=j:�v��ҧ�Tf�}������[��K�#������KJ���V���
�0��KHOU�� �� ��I �+p�@k��m0��g�ifi�VY�ߖ�H�m�h���	��wF�L��¸X)j�H����Oե��@���/����ڊ	j����&� k���A���q�E�6�Wm�-��,�H���a`���Ā����+�Mi���
4-}ӳ�>��o�5�憄�V+_�ƀ���[U6`�t'��(��F�}T��x�=��rA��������s5��w�(�uOʉ�h_����+�79��������?���j�qD�3w/�@W��Ć�@i��`	f�Cy.�Ȯs�l�!�����~�L���G�_yk��QK��\lZ��|�������`ƴ-[����kݥ��k*x��A��^1^������ub�.}�V�:u�N �n��t���5C8jP�E���7�3��K��z��7m(I��p�4}|�i ����8��?��q|煆�x�����ߤy5Ѡ��ꄝ84�����V�߇b�|����܃i�P��C�"� 4����?�A��41�G�_��Kyߟ���o[x�����͝�%2�挷�:������2�6��>��]Z���:� 'C����l �(7�_/zP�.� ��a�����{���L�~M�<h(%�j�r�]i0$W�Z��}&�����	��d����n<wڼ�>��/�2CF��/D�}5 ��y)��˚�Hj������� ���Eld��"^��,�	��Hao�i�Ndߤ��Џ���Q&�I_�ށw��|An���j��5y���Ǳ$sn�c9��� ���� ��^�"�o`�Հ�DG����H����7��F#����om�o�I�ʷ�4��u$�+|{��O�E::H�B31�V�Y��[&JJs��-�j�`�zs߂�������Ԅ���0-��8�מ��U''���?$�#����<P9܇��vx�
�� �� ���B�ߝg�|�:E|TWk�k�N�w�A-h�v�u}���E�o�Vؓ�9ބ���M�C�{�������d��6� �����Gt���G��%����Ăj��۴iBm���Fh
F�*x"�,��YML0�ߏ� �![�ʯ/}�܏04v�(Ґ�~;��d�Fy�����_W�ߗDЯ��E���+ͯs�h(Ǡz��J/p���}h``2�&����Å3��� �zHC��	�#Q������(ԣ�'�	-oC�������%+���W@�{����e=�X��������n@���Ɨ	g�ЧlX@�X����8>3�*��V�.(`&�vu�#��}롩 �����_�7�C��ݤ�.��E%�N�]I�g+��p��`T ��E��K��u�+'��XlgK��~I����4t�J�1�W���+�'�I�Ӄ��$������l�q����c�N4�"��d�/��6��=.�AY�Rv0A�'כ���w��}q��j1\n4�]���(��M��&��>���N���^9t1ȷ�+i�з�`�����i�H���
�� W���e�߹}��д'C�"��.����y�
��\Aĕ���Oc.�Ж�����u�c��/v
��aY�����'�}�c8��=��4�'��Yq�h�(�7�w��L'۳���\0�ff��It���bHQ9H��o<=I�[��Є7���Q�Y�;<�R/�B��
G�f*�3��3���xf�3���@�������}�Oof`^z��8+�,µ��Ï�[��M~́:�������8�`b�U��;��>fȄ�1.�z0̐�qj���e~ _n
x��C�i�'���-�\�7݄���Ðο#��c�7�~GY�9�G��aY�c�[�$8˾�(ru"p(���lg͌��eX8Os�n���l��C_K��]�N8�5�!�vO3���e�p&~�OW���AQ�>�P� 3��Q��Gi�L��&��A�����fh��k@f��I���@��Ԃ�(2���_���n�LT���e�:|*�M&���w2M 9�Z�	�,�X�c���dr2�dj6\���¥�gśn���%�����p�`�>�P� � G4���cB�$rRl��c}>�X!,E'JA����x�]8c8q�O��N����@}��� 6ƻ��*�ۀ �Pj�y
א��������0�2d�>DHJ���B_SP*H �"��3�Ù6]©�86ؾ�.�]��x�,-��S��/��3�Mp�� ZhF�f8�R��S�;���l�[�p
����(��z�y�}�������%9��9��-�~�������?�����Eon�dh����?���y���i��q�G��ldH����!q�G���}��δ_N�{��O �����_�⨓�@RGR�%�T���n���s?���Ǐ��?�-�~���!�h�w�
<��?Ă�y�����Q j�߻��DĊ���? ��X��q��g/����n��<���$m�&�i���(��)���lJcL#Cr�E��EY<ǦiC�M�5(��R����]?�������$�R����E�ЩY�(5�D��t���(���쬂!
uYV�ٸ��I'�:�ۛ?-�zo]�2���T��>7-�Cqᄎ@"��ON�.����<Ի��j��ee�<�P�E�5RM���X���"�?�y��o�
�^�F�����d��)2��T,[�q��mIw��
��gܺ�c�8������Y<�G��������`����=�ǁ�i����?���������~fٷ��ψ�T��/����_��&�S����NM��Ȍq��(����RX��Q������[�������O��0�G�����ul�b��SW���Q�G��<��n����P�l�+�6��|3[�S�S�Ǟ��*%�YٍH�8"����Q�E�&�iԯW���y䦲v�$��*]�r�ta����55�lĝP�3趄I��6T��}�"{3����=ۙ�nOj���t� {T����7�ŁnWf]Y��~��c�:���V͍=���J���%�n���[����r��]�U�j^�>R�kB���
uI�?�����z]�5r7O�v.�[���EU���eź�8B�.=�n>����R�U�d��L�ۈ�zG�Y�{���Σs�i��'xA����Uj	#MK�:��3K�ٙ%��!+޸@7��e�)����l�_JwM)-8�8;ۑrW��C���7	��g�>����s�A���+�h,�E�����o���X����_���.��`�?"܊���?������7��c�?��^{@�?��v�V����3�J���?"G,�������#^��c�o����������8�ǰ�2{���ñ�N��K���3F�62:GsVϠ�E�L�dM�� �_��xC��T����r=�+z��zƔ*S�lv�f�����H&�+u�ݽ�c���º��R��2+t��:�M�iQ}�����|e����J��X?u��0�ǭ1U�2s!����b��qO3��YMm���?ދ8��8��������X��������n��x	P����!��������p�,�E!������?�����?n�����ul�b����7����m�s�-�S��jm�4
��t��=�����>�%=�ՆE��cKhe�FPiJ�X�j6�UDAh��jZ$ҳ�]m�w�c�#��;Ѥ��F�lVoU�l��|l�n�V��9RĖ֨��v�r�B�#	g�|�p�H�9c0/94�"T�Z_OC�]�wV`D��O���G��Y"[o�-I@7[~��$a��T�(	þ(ugz����Af���օ��;#)��$�.��q-k��&mt�i�E��9a(v�ɔ[�\?v��턘�g�,��jS/O��Z�֫O�F_T
�Ne!�r�,�d;�=)ٮ�3�R�!�ȱ�bTB���|�8����9� ����C����/`��s�q���v��c�<���o������������C�ռ���t���$������<���sD������/,�<����,�^�?�������"���fZcu��JO�T��Rz*��֣z&�d��E�3)�%3dZϐ=��2�aYN�Q>>Q���k�?h����?*�~U��yE횏ϝ�VOW��J{6�ܼZ(2��vWS&��b�*E6����xu�=�rƓ�8��{�?�IS"�φ�ѭ�Z2�m���e�Z����ȼ�鵋ޣ�<��?�T��lF8�ǻ����Y���N�x�����"�3|L�/�oo����	� �S��?8�k$�����K�b�(��������?q��$����1�G��?t1�����90�c��9�SW������������1b��G�?�������g�+���/ą�3<�g�t�N�2��kk�5.�Q͑���dhͤ{&O��0zL�ɤҽ�ni�tƢ���}����������h��o�lX��ޢ+S��*�3nӾ+��-�����s��,P��|��;o�)#9-�5�yV�4��]P��ė�rvl�G�N�m�,�ʮ��]�H��BI�����֕;Wf�REoX�����#�����F���X������Hp��qc`��s�������������m�[,2�@��R���/���#������/S���j�]j�8�j7��eR]Ihu�y��<+�	7y�#�L\�Q��U�IDEIh�8-��l���qSUݓ��MU˵a7&�����*��y䦲v�$��*]�r��׶��8\S�ݍ��~F�!L:-��z���M����}�̞��V�'���r�W�=��}L���@�+3����P�J��%��jVAu$l�2��1����6#��~��F���V}Ǜ%��'����8rr��&Gʌ!
��2��q��x����ɵ<)L9�6jfa�֟�����'FS�O���Z~�H"$Rк��5$��e�]�$�[���϶��z!���<�v���ì��4��0�����-��'ҸZ+�z�p�+?�캶ʺ�b%VC�!� @dA���0�jܘ�͝j��-Gm�Z�W�g���SW䤹���%��J��
=��{ܨNgQ��r^�gksq�Y�fڝ�5'n�y��s�Ϸ,���u3�X���A�X����_,�?�a��F��_��� �X����_8���x]���!��sI���r���&�)T���]��y����,.�m@=��@0���x�x��"l� 
���&��-��� �Ё��z��3ln���TNޤ��Nޭ�k��ov5�VY�Jچ���J6���$���Qz��z5�p^�Tj�c����Y��tq~ ��σ��}�����/�Dw�Oz�b���R25����ES�������ǹ*c6�����b�XiRW)��e�n%6k�V/��Z��OU�d��J��ne
�O�?G,�?���|�c$�������1�����X�?se�7��	b����#�B�������������������	>~�ߟ�GD���������(��/���!���}l��Q�gY��Q ��X���?��o��a���B$�_�Li<O�?{O��8�]c��ltȡO�`3[����i���m�x}жږ�e�ݳ��Jm�Ԑ�ew�r�!@��`� AN�\�{rr�m/	��KNy��!R����g��iK�z��U���*��L"���fv���6�If3q�N�t�Զ���h"��tvi���4���d���L�����#������d��?�V��'_y��˃w�/rC�5���N�ې��Q����(��Q���2ۛy�O����U�:��~�z��>���i:��o��7��p���ϯ�R��zl��e-�{�N��We=��9}-T�'v��ib�����>�*�PйKCS��(��'��������I�CRؼ�p������L��|�r0�w�����u��@��b�&�JO3��v<�`w��QY#�9���vŷ�y[����o��0�j��\`���^Sulʥp�-eWhi'x,��mCT���zVkV+|�T�Ÿ^G�D�ݎ茍�A�ؠ�o�vY��KX�F�"�:�m:P��sQ6�r����ǝBY�֮��0�����������ߦ�zb��IWT_�?������6���D7{��{�����'�q��9IFB!dY�F���9�%�إ9��+��w�fI���d��t4�Źx���C�kY��>(Ɯ���d?_����b�鹽5�X V�YŁ���Gm�e0Xp^_T�9b�HT"�I��$Q��p�#+�,ly���](���|�נ�h��ےr��`!�6�kM��g���^љ[��x��(�To�b�B�� �.��9��N������gN�j��f��/�{��L�7�Z�*��{m�vǥ�Z������������1���m��`e�Ο�K�/{q��7?��P����r�"���q�|X�`��̑��]���k��q5��j1A��W�*������LS N���DP?�06�c�**���"��A�6ݚ��+	xQ4��\\�%���i���V�֋ya���DW7lM��d-�_	:�~�Hi���v�mYϑ�60c]m ����K��l��-b�0�f�ՙ��	=�><s�T��d��à>��y\|�I/G>�6뙤�Z���Zl
��"�s�6�z��=�.2�X��{�T��8S��٣l�H_���!�ڐ�D,��A���i�@lS�e��h: ��X-���"��d_ޘ�J� ��U��Q�DV	8�^Ekp��8�����0
���aE�aV�'���,��'�j�o���Y���+|�������X�3`P�哃���K|�����]�3�!�g7*��J���I}o��7��0��]�zL�1���f5OyP+�y��/�՚��X*s�q�S�,� ��b�d�|p��ko�#P��*��f��/�p�ͳ�c���`,��I�����f�?��f�}D	����h!�T�����",�0V�6�gL*;��h#�\��&�D�� �� �m:��Db%D��"���h�hXJ�)$V@s!7�͒h��,fW��cS�]��x\���,�ϫ��
�֞�iG*��.��T�`v���|=_��������g��R�n����dQ�X8>������0'j��͌��d��ʸ��V�f�LW[���c���㺏=�yJg�G��a�,�$��1��t@նф���ϋ���y,c�a�a��u^�x��F��,��0+�[I��q��Me�0�>�Oj����5��l��&�c	gVZ[µ%����j	�S�p�;���{Z��ZB�����O���*�4j�?q����n'R����dv��� )�e�|I��R�&C8����@���.�"k��$�8�@��]�|�(��ꋷ�EL2d��l�JNo$:0�eB��Ȣ
��k���!���B�OD�0�_/ A�2��m��hĉ�XNӻ1�3b��""��$�̲
g�B��殬Cg[��E� ��LE�@��S((�2��-bhs$�Ѵe������C�� #&�$�HY�ea�����z��|��?��y�Tk`NJ�z�z��I���OJ[��hQ�O:� Ȕq$i��@��te��PI��tM���$]$\E�
�/8��F4�ܗMK�N���B�Z�dF^�B
5I�#�=gP7��N5#��6�������n`>+0q�po1�a8��{n��q���3� �h�&��k��+�@v50EtX�S0�ފv�K��u���h���,g#�W������Y6�&�$s��sP��&�S���E��0Q_D6I�0!�ٰnڧ�rM��s� ���(2�E�u}X���"3�� �8�ܥ&�M�>0t�"0=���L6Ԛ�w�]�)Q55����۴�v ��"��`��0l�_Q�d�ի�j���
�/^�z��>�QQ0��{+�5���9�L܈X�f�& G�s��X�E*!��nP@{v9�E�ٰ�oN3�(�4�4N-��p��`����+/\��h� �18��6�p�J����iOQ,6��E�C"��Fn/; ��k�ıə� ����������G�������PW�|��}�0E F������C��� ,�q��� �B%o[�D��R�i0�և����ɾ16���dW�=�6d182,�&X��Dw���LJ��N);o�a��S�sY9tgQŁ��,o��}�0�A`(l\�=�G�.��d�V5���$!qhkUu��5�1�
�ͭ]D�.2Խ��� �X��P�0&= �����n0
&��UA�PB��*ʸyT�:�E���E$2�=�U�"SP�T�l�Ȁ ?1߿K:�GL����'8�&����� Λם}QV,�e���'���B/��fO�FL�x]�t4�8����첣�}f.a��:r�}���/����~q��^x'��#n	�eڊ֐n���gT�>0�v�I��r�/C��`$2K���!���� u��i9;��!����2�����2Z��?wa8��!(�=0Y�Y��BdsbvfO�5�m�'�y�<H ���F�A��sX03��0�D�s�®>��0"V�Y��Ad�z\��ᕮ���-�5�ȃYtk���":e���C�2"&��3��N���|ׁ�:-�VZ�S?�g���[��E���S��O*��g!?�Jg���?���,֒�XK4z��3���&�Ytd�1Eճ������8��D�5�9����DC]�X��4����8Y��"�	~؞|_��M�zV+����ޅ�fM�`Ԇo�_��6��[����=�$}��3I�%ݍ��K\���(�[��[&����3�����V��E�u5�H�����\�O�����$}R�� �?������e����Ǜ3�bD�Sk���E���
;���t_TI� ���^���33�%�7������؞�����/���/2��.ǭ�7$��l��~%CO���+"�H�N�ڵ��qSݤ�gz�D���g�bOV�K�с�Ẃ-p4��(Ǿ�.���t\6�
���PQ]�'Y��us� `��'�)�����d��,|������_��c��ʪ: �Wa�p	Ys���A�K��+��c.���/,}�q�?���P0=�H�|���K2�G�.:�L��J�ik�2�QՉ��碌ӷJ�Rv,R7���z�Vo:g�Rp�C'�ߢ��!*�4��� ػ[��Yb'����Xٸ����	a����{ZI�۫��:��bK�H�gә	�/��&���!���U�p^��n��/�����*Կ�����~�$�䫯_�'_/I��'�U��xo]�Afލ��bLnc�n�n�{9�2��"��{C�玌{��]�ݝ���ˌ3�x����}�we kY�1�Ў�t���D��(�dgw�	`��5D�J4�)-�r�?�e?��E�ܹ�����d:����!����͟'��?����If����Aң��&�(��8*��ޗy�����s��������T&���I�u�wz�d���^��]�Z��d�Lj=�io��9p�Z��ҕ�CZ��_�-/����y������������w��a�Ɯ�g���?�	<|#�)W't�v���x��^Q3�]T��ϴ��VW��tچI�E� ���_��/q�_`Zt�k:;���ڎ���� �Oqy�Я%|�u��c����(��7�EB�G�}�$���R�kB��.��?��������d�z�xr����9I�Izs��;"A<��?�WK|�/z.J�sM¬\M4q}��T��Q�����"a{��I	���},,/�ųZ�~1}��4@�z|�A�ݜ���������b�j��A�Њ�^��c��!���̋�g�q�}O�{�J�LQ.(�ڏ�VY������%��tvR��`���C�G��c�;�?ƼBv?�p0c�|%��m��h�5��6a�๳�>ca��p�B�zs?#�D��v)�
���
��<�`)�~W��j��UKϯf+�9����_��
���+���/w����"�X��� ���h�Fd"��a��˪�˴�����Ǔ��?RS��	���ɶ����+�x����ΉL�����{��
Uz�@��ڟs�w�c���Ɋ�ak�)���C�G�$>�		PIsB�����@��p�c��;-���%2N�����<�Z?�� 	UUC1�if`��_�d��s��m`�v�!U@Jmo�p#��{n�J94�7=�z[�m��:*� �@�A#@3��Ĳġ��t��ھˬ[̢I� t�H���t��9�]�1AS��,<����(^�GUI�X����dXא8�c?pŹZ�w��L(�!,�s��A���۞ظi�FE]��׌�pw�@0��J9�]c��<�]
�B��S��*̍v��VQ�Ksq_̰]�;Q��IcgY���J=��g�S���v��O�Y��_&�Me��'$������o��]=��>�я��~�/��}�%���V��܎����]qWL�2����v*��ʈ4�+fҭl�wu'�N��턔�RTLӧ$�C�n������?�����/��#������~�7Ϳ���|���Я�B�F?�����~Ͼ���?���������5O�㧟�����������~��W�����^j_�.��|M�^j?���ݩ��_z��>��fY/gϏ{�I�.�*��Q�~5:��G�,��ϻ̟{�O*�'�_*��*�[녩�.�<ߝ�������ų�N�puV�>/�Z�d��M�7�}~;,��ɤ�}~��l�޽���W���ѷo����N�&�4:��^�.��~���FjG�l\�~��_��^�+�|�{1�
�����Z(\��ņx5��6t�KG;��J'v8����V�W
;Iy��R�pl��yA,{�|����g��b�u�$��7�����n|�D�x��/��Q�����ڡwoN;j�ܭ�o��>X��兮kG��(��L�H?Ī���E�(_�i�^������i�Gu`�v�b�n��?~����u�;��n����7n�S���?��^1N*�*�F�rÿ��
ݓ`��Nz��6�������U&�K(�!��?�H*�.�;7���`h�b���ۻ�ǭ:�-�v���;�U�vJ���Q�8Χ@��߉c'N�O���8·�8q;>�@��� ��B�ġR9C�		Np���*TP%�(���d�����ά��
��x��~y���/�4L3��to��X������Thpnȓ}�K|Ja����,87�:����W=ڇ�卪*�VI���*���X�f�eϮ���z�jI������	�K��r���ӭzO���<]7���ن�y��ۖ�8�
U@�����dsJ��Ls�X�(W�!��M���ƫ��^�#g�GX����N�&����V���
�Xҕ�<��S��1:�)
���z�M6R~�Bj)�2 nE���8 AI��]��Vuw�V0�.eV��1d`n�,䥥��Q\��<�;c*m���BP�qy-S���� m1�lN���2�ht��P�;���W_�y��,@�ba��b�8�y{�N���i�43�j�K��c�����L��6���=iPe�9����ܐ�hF��W�{���5K����r�[g�V<6²>��`baS:_Z�78et��]�D06l��V>MdM7�u�-�۶ʇ!�h�2�d!k��t�^�;��9"��H�"�%�4��~�5%�X$�*����%�� �Ч����O�<���p��S@f�|AK�#���Y�(������
'���H/��@��G�3!k6-�+�J-�s�\��i���m���y�1�zFğ��|O�:R]Δ�A�

w�X<���5���E=���Å��tƙ\�����8 �,��:�WJ�I��.MV���5���F��Sb�\���rFl��F?ƋŚ=k�^]<��@ŒJN�y�-�@�$)��`�o�n1�#ʇt�h,�(�X�#�1�������em�,:����@����Ԃ��Xf~�R����4A��,ߎŞR+��f6K�-Oo�44���ng,�m��;�X:'0�L��"0��K$ǅ�0e�5#H�g͉���r"����a�a�w�m�2H�c�oԚZ���0K��.)��>����l�J�x%G�� d����5]!n1�#ʇt�h,
��G�X�p�ڨ�Ifud�;S%�owi�6�QUKE"H�&P���5����F���J�H��[��mi5����H�2�*��.��P͆j���l;�����]<V�������}~���ma�χ�ڹ�=��(�n�G��@�sm��K�m��m�*oh�S�j�y�5�Y��K��d�]�������Vy\��,77�����]��>�gZ����������-�.��q�����n���Qg��mc��#���Uv���ھ�=�]��7o�E\�y����]�5���g0��{���py5�4��X�{
�(?����뭇m��bSg5�w���up.��X�����{�XY�y�~���B_oF�=sl� xt����w�cb�{����re��|��}���}��z� =����ջ�na����*u+R���N�1M�):Y��t$�D�E��P��8.����g�t�質�hnQ4%�J�s�r-HeQ���e�R�iޓ�b�����T�юV�;�s�[������2i��e��9� FeI���>�jH**��
Υ���>(��]�NSil�^�E��٭�`ݖ{��p�!dCf{I��/�Y]��EG���f%���d�Jڑ�q��g�!x�17��QS��i��u��TKd)(n�)���X��S	F��,�a(�s�1
��3���������y8	.R�+��N�)�m9�&��f
�?L4C���'$�]�nj�$�X�(���@�!���m?ڷ�� jl���!=�v:N�/u�|o���$ix��2�~k��DbT"�����	�	k�Gk�:�&���v*n>e��:�.r��9�Rǆ���g�����¼�/L6[�j�� ֕��gŧ7\�.�Լ�
+|�
+���K�cr��/_a��K�����$��I���h�*���.�YE�$��,q�ͣ�ق#��PT��1*w�N��C��
�
��z���f�6<��̇�r��eԳ�D+g3-����gs�h�s�>ꇒ���	�S�VI��Ą	25{��]�Ñ	�>;�y1�Ws!�LV(o�!G�pZ0� ���z	�t�'L��U{�X�u|B�b�H!�<�a{d�H%��B�i$p�Rk�üK^3j�0k�r��C��Ȅ�BW�$"5҃�W�Y�ݒ�ċ!@�i���:�"?�L�0��T9�I���9���s���	F�NT��O]�jq��D��	`����؎�ƚ�9�
��DOF�p�߁\�P��G4a�1ߩ�p�Q�.�6�^�J_�_����9�B��a�8_`8;k@�D���-8�K�|<�=�=�.s_kf������t��g�FH�����_����}���~��q�m���P>h���2v��鬷ˬ[g�����O2z���E����y��7����K�w?����|�r���՗t�o����ϸ_^�i��?ɀ8xz��<�o�z��0��/�����]�0��s_������z���͢�G?��g_��"�D�O"��j�ۻ�G����#j'�v"j'�	 � �v��������F�4�v"j'�v���l�j�����z��ʓ�@��=�sAe�g8�3�#���1����3&������篮clP��� �u�g�^��W��g��9���G�X��̰.�>�Xfs�J��Ah+Z3���eh�r��a��=����%0�ce΍���N������%��!������-�!A�	$H� A�	$H� A�	$H� �����   