clear all
subjects = {'H1', 'H2', 'H3', 'H4', 'H5', 'H6', 'H7', 'H8', 'H9', 'H10', 'H11', 'H12', 'H13' 'H14', 'H15', 'H16', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'OA1', 'OA2', 'OA4', 'OA5', 'OA6', 'OA7', 'OA8', 'OA9', 'OA10', 'OA11', 'OA12','OA13','OA14','OA15','OA16','OA17'};

excludes = {
    '[79,112,191;]' % H1
    '[44,55,67,91,114,132,150,177,198,227;]'
    '[7,16,26,31,57,60,65,68,76,82,87,91,103,108,116,126,142,145,153,158,163,172,180,181,184,196;]'
    '[9,10,49,77,89,170,209,223,242,276,286;]'
    '[4,5,26,51,52,67,68,83,91,97,106,116,118,119,129,133,153,166,169,175,180,181,185,188,189,207:212,240,252,253,256,288,290,299;]'
    '[3,34,76,133,134,135,166,191,247,295;]'
    '[31,44,79,109,120,168,175;]'
    '[4,43,50,140,170,197,241;]'
    '[48,114,143,162,186,198,209,233,238;]'
    '[2,6,78,95,98,102,111,154,157,163,192,196,205,237;]'
    '[21,65,96,97,107,126,139,148,184,205,225,232,237;]'
    '[2,24,29,61,64,82,90,99,111,144,167,175,186,197,206,225,246,259,261,270,287,294,301;]'
    '[9,10,19,24,35,66,70,76,99,103,105,131,137,141,149,153,154,174,175,186,188,199,206,207;]'
    '[1,12,26,47,66,73,111,151,154,156,173,202,237,243;]'
    '[46,72,119,150,166,238,244;]'
    '[10,41,68,85,97,114,121,123,129,142,158,180,203,229;]'% H16
    '[6,12,19,38,68,82,109,120,121,126,143,150,172,175,193,226,231,237,271,284,306,365;]'%F1
    '[6,12,38,48,49,55,94,198;]'
    '[6,8,27,31,36,47,59,72,75,120,125,145,151,155,188,195,211,212,231,255,284,295,302;]'
    '[12,21,31,36,38,42,95;]'
    '[77;]'
    '[20,39,45,82,136,188;]'
    '[18,90,165,171;]'
    '[1,67,130,173;]'
    '[5,39,45,117,137,149,179;]'
    '[19,24,50,64,84,88,94,114,152,178;]'
    '[10,12,38,40,79,89,100,105,119,120,150,167,175,210,226,235,243;]'
    '[3,71,120,170;]'
    '[89,119;]'
    '[14,89,95,105,121,164,195,203;]'
    '[9,12,33,83,93,117,137;]'
    '9'
    '[4,20,45,52,57,74,85,134,137,138,160,162,178,189,196,197,210,212,249,251,275,285,287,300,302;]'%OA1
    '[24,25,47,48,54,77,97,106,127,141,149,166,176,192,200,216,230,243,253,257,262,269,282,285,293,294,301;]'
    '[24,123,186,209,242;]'
    '[11,22,25,63,68,76,92,100,110,123,127,142,184,211,223;]'
    '[1,72,77,78,91,110,137,143,154,161,205,234;]'
    '[23,24,36,49,55,60,85,99,110,139,164,175,176;]'
    '[27,28,87,110,117,120,144,149,175,182;]'
    '[16,41,82,89,136;]'
    '[25,58,117,181;]'
    '[7,19;]'
    '[35,61,98,113,124,169,173;]'
    '[6,62,69,115;]'
    '[4,14,39,40,66,88,98,140;]'
    '[2,9,17,25,31,35,40,57,58,80,99,102,114,119;]'
    '[2,7,30,50,59,66,69,82,89,101,102,110,113,152,162,171,176,177;]'
    '[39,49,110,164;]'

    %'53 54 178 183 225'
    %'1 24 27 29 51 55 65 70 74 75 76 80 91 95 105 128 129 143 150 174 177 180 183 223 227 233 239 242 248 279 281 282 283 291 296'
    %'8 31 35 36 38 44 45 72 74 78 84 85 86 87 116 118 124 126 128 129 141 142 149 151 152 158 166 184 185 196 211 212 213 230 238 241'
    %'10 20 27 28 35 39 58 68 81 121 123 134 171 174 209 223 236 256 269 274 277 278 294'
    %'35 42 50 85 97 119 127 180 181 183 186 189 190 212 223 236 242 251 253 289 302'
    %'166 222 293 295'
    %'31 38 44 79 80 89 90 117 120 132 135 143 154 165 174'
    %'50 65 170 203 228'
    %'19 29 30 40 60 114 119 143 152 169 179 198 203 228 223 241 243'
    %'2 40 55 77 78 98 150 155 199 237 241 243'
    %'1 4 21 25 33 34 36 37 38 73 80 83 87 89 90 95 96 97 98 101 102 107 152 183 190 192 196 208 209 211 219 221 222 225 232'
    %'4 7 9 10 11 21 24 26 29 51 52 53 55 58 61 99 109 111 113 114 117 119 120 128 129 133 135 137 138 141 144 154 158 162 163 167 171 175 182 197 199 205 206 218 220 225 226 235 246 247 250 255 261 270 287 294 300 301 304'
    %'66 68 70 81 89 163 174 175 196 208'
    %'1 3 9 14 26 28 34 43 78 81 84 85 86 88 91 97 99 100 112 113 115 117 122 144 148 154 173 170 177 201 202 223 234 242 243 244'
    %'38 51 81 91 150 163 164 171 190 213 238 244'
    %'10 68 97 123 129 142 178 180 208 211'
    %'6 8 12 19 26 27 28 29 39 40 63 68 69 72 76 79 80 82 83 85 96 108 109 114 118 119 126 127 135 143 150 155 161 166 168 170 172 174 176 179 180 191 195 198 200 202 205 215 217 218 225 226 230 234 237 240 241 245 263 317 329 333 338 340 341 344 345 353 365'
    %'6 16 17 18 19 20 56 57 58 59 60 77 94 97 98 99 100 103 105 114 136 137 138 139 140 148 167 179 180 181 182 198 200 210 220 221 222 223 224'
    %'23 31 41 47 55 59 68 75 106 120 145 151 169 186 188 212 231 278 291 295 298'
    %''
    %'3 4 7 9 19 21 23 28 29 36 46 57 68 76 77 79 97 100 102 103 104 106 115 123 136 138 142 149 158 160 167 168 176'
    %'1 6 7 36 40 80 82 96 107 108 117 120 134 188 205 210 219 233'
    %''
    %'1 3 30 58 63 67 82 87 89 98 110 114 119 151 172 177 178 179 180 181 183'
    %'5 7 9 10 14 19 20 23 26 30 31 35 39 40 48 49 50 53 54 55 56 59 62 74 84 89 91 92 94 98 114 115 117:120 122 126 135 169 176 177 178 216 218 228 229 236 241 243'
    %'19 20 79 84 88 114 151'
    %'10 12 43 79 85 100 109 120 185 242 243 244'
    %''
    %'8 89 119'
    %'1 11 13 14 32 33 45 50 58 61 64 65 68 70 72 81:84 86 87 89 95 97 99 100 105 113 116 117 121 130 131 133:137 167 170 171:173 175 204:207 210'
    %'1 9 12 24 29 33 42:44 49 53 59:62 93 94 98 99 102 115 116 117 131 147'
    %'5 52 53 55 76 87 98 99 107 109 110 111'
    %'42 46 74 85 134 197 199 212 257'
    %'3 17 24 35 40 52 98 127 140 165 169 170 172 187 200 242 248 250 253 255 257 258 267 268 269 270 274 276 280:283 285 288 289 290:293 298 299 300 301 303 304' %OA2
    %'119 123 209 242'
    %'30 68 70 83 92 100 110 127 129 130 138 140 169 170 171 173 174 184 205 211 214 223'
    %'2 131 137 158 233 234'
    %'10 23 39 49 55 75 85 105 110 129 134 139 148 151 154 174 175'
    %'2 4 7 28 30 77 80 88 94 118 144 146 179 182'
    %'6 33 48 126 165'
    %'117 131 132 165 172 173 180 182 183'
    %'18 26 84 87 125'
    %'7 44 45 51 93 114 124 149 151 173'
    %'19 33 46 47 58 92'
    %'4 7 9 14 38 41 47 52 57 68 89 111 127 132 143 144 165'
    %'1:5 9 21 24 25 31 35 43 44 48 49 52 57 63 64 67 80 85 98 99 105 112 119'
    %'2 7 12 16 17 19 21 22 30 39 45 49 50 57 59 66 69 75 79 82:84 86 87 89 91 79 80 100 101:103 110 113 115 119 120 162 167:171 176 177 179 181'
    %'11 12 17 18 20 23 25 27 28 41 42 46 49 58 59 60 67 71 72 80 88 101 110 118 119 126 132 133 141 164 165 172'
};
 
 
for subject = 5%1:length(subjects)
%s='.cnt';
%files = dir([char(subjects(subject)) s]);
 
events_mat=[]; 
%for i=1:length(files)
    %x=loadcnt(files(i).name); events=[];
    %event = x.event;
    %stim = struct2cell(event);
    %stim = stim(1,:,:);
    %stim=[stim{:}];
    %ii1 =find(stim == 1);
    %ii2 =find(stim == 2);
    %ii3 =find(stim == 3);
    %ii4 =find(stim == 4);
    %ii5 =find(stim == 5);
    %ii6 =find(stim == 6);
    %triggers = find((stim == 1) | (stim == 2) | (stim == 3) | (stim == 4) | (stim == 5) | (stim == 6));
    load([char(subjects(subject)) '_stim_matrix.mat']);
    events(:,1) = ones(sum(stim_matrix),1);
    events(:,2) = [(ones(1,stim_matrix(1))*1) (ones(1,stim_matrix(2))*2) (ones(1,stim_matrix(3))*3) (ones(1,stim_matrix(4))*4) (ones(1,stim_matrix(5))*5) (ones(1,stim_matrix(6))*6)];
    events_mat = [events_mat; events];
%end
 
reject = excludes(subject);
reject=reject{:};
reject=str2num(reject);
 
 
events_mat(:,3)=ones(length(events_mat),1);
events_mat(reject,3)=zeros(length(reject),1);
 
ss= ' _block_info';
ss= [char(subjects(subject)) ss]
save(ss, 'events_mat');

clear events events_mat ss reject 
 
end