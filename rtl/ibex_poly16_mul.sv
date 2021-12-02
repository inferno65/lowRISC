// Copyright lowRISC contributors.
// Copyright 2018 ETH Zurich and University of Bologna, see also CREDITS.md.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * 16-bit Polynominal Multiplier unit
 * The implemenation follows the circuit optimisation introduced by the NIST circuit complexity team [1]
 *
 * [1] https://github.com/usnistgov/Circuits/
 */
module ibex_poly16_mul (
input  logic [15:0] a,
input  logic [15:0] b,
output logic [31:0] r
);

  logic       t1,   t2,   t3,   t4,   t5,   t6,   t7,   t8,   t9 ;
  logic t10,  t11,  t12,  t13,  t14,  t15,  t16,  t17,  t18,  t19;
  logic t20,  t21,  t22,  t23,  t24,  t25,  t26,  t27,  t28,  t29;
  logic t30,  t31,  t32,  t33,  t34,  t35,  t36,  t37,  t38,  t39;
  logic t40,  t41,  t42,  t43,  t44,  t45,  t46,  t47,  t48,  t49;
  logic t50,  t51,  t52,  t53,  t54,  t55,  t56,  t57,  t58,  t59;
  logic t60,  t61,  t62,  t63,  t64,  t65,  t66,  t67,  t68,  t69;
  logic t70,  t71,  t72,  t73,  t74,  t75,  t76,  t77,  t78,  t79;
  logic t80,  t81,  t82,  t83,  t84,  t85,  t86,  t87,  t88,  t89;
  logic t90,  t91,  t92,  t93,  t94,  t95,  t96,  t97,  t98,  t99;

  logic t100, t101, t102, t103, t104, t105, t106, t107, t108, t109;
  logic t110, t111, t112, t113, t114, t115, t116, t117, t118, t119;
  logic t120, t121, t122, t123, t124, t125, t126, t127, t128, t129;
  logic t130, t131, t132, t133, t134, t135, t136, t137, t138, t139;
  logic t140, t141, t142, t143, t144, t145, t146, t147, t148, t149;
  logic t150, t151, t152, t153, t154, t155, t156, t157, t158, t159;
  logic t160, t161, t162, t163, t164, t165, t166, t167, t168, t169;
  logic t170, t171, t172, t173, t174, t175, t176, t177, t178, t179;
  logic t180, t181, t182, t183, t184, t185, t186, t187, t188, t189;
  logic t190, t191, t192, t193, t194, t195, t196, t197, t198, t199;

  logic t200, t201, t202, t203, t204, t205, t206, t207, t208, t209;
  logic t210, t211, t212, t213, t214, t215, t216, t217, t218, t219;
  logic t220, t221, t222, t223, t224, t225, t226, t227, t228, t229;
  logic t230, t231, t232, t233, t234, t235, t236, t237, t238, t239;
  logic t240, t241, t242, t243, t244, t245, t246, t247, t248, t249;
  logic t250, t251, t252, t253, t254, t255, t256, t257, t258, t259;
  logic t260, t261, t262, t263, t264, t265, t266, t267, t268, t269;
  logic t270, t271, t272, t273, t274, t275, t276, t277, t278, t279;
  logic t280, t281, t282, t283, t284, t285, t286, t287, t288, t289;
  logic t290, t291, t292, t293, t294, t295, t296, t297, t298, t299;

  logic t300, t301, t302, t303, t304, t305, t306, t307, t308, t309;
  logic t310, t311, t312, t313, t314, t315, t316, t317, t318;

  logic z0,  z1,  z2,  z3,  z4,  z5,  z6,  z7,  z8,  z9;
  logic z10, z11, z12, z13, z14, z15, z16, z17, z18, z19;
  logic z20, z21, z22, z23, z24, z25, z26, z27, z28, z29, z30;

  assign z30 = a[15] & b[15];
  assign t1  = a[15] & b[12];
  assign t2  = a[15] & b[13];
  assign t3  = a[15] & b[14];
  assign t4  = a[12] & b[15];
  assign t5  = a[13] & b[15];
  assign t6  = a[14] & b[15];
  assign t7  = a[14] & b[14];
  assign t8  = a[14] & b[12];
  assign t9  = a[14] & b[13];
  assign t10 = a[12] & b[14];
  assign t11 = a[13] & b[14];
  assign t12 = a[13] & b[13];
  assign t13 = a[13] & b[12];
  assign t14 = a[12] & b[13];
  assign t15 = a[12] & b[12];
  assign t16 = a[11] & b[11];
  assign t17 = a[11] & b[ 8];
  assign t18 = a[11] & b[ 9];
  assign t19 = a[11] & b[10];
  assign t20 = a[ 8] & b[11];
  assign t21 = a[ 9] & b[11];
  assign t22 = a[10] & b[11];
  assign t23 = a[10] & b[10];
  assign t24 = a[10] & b[ 8];
  assign t25 = a[10] & b[ 9];
  assign t26 = a[ 8] & b[10];
  assign t27 = a[ 9] & b[10];
  assign t28 = a[ 9] & b[ 9];
  assign t29 = a[ 9] & b[ 8];
  assign t30 = a[ 8] & b[ 9];
  assign t31 = a[ 8] & b[ 8];
  assign t32 = a[ 7] & b[ 7];
  assign t33 = a[ 7] & b[ 4];
  assign t34 = a[ 7] & b[ 5];
  assign t35 = a[ 7] & b[ 6];
  assign t36 = a[ 4] & b[ 7];
  assign t37 = a[ 5] & b[ 7];
  assign t38 = a[ 6] & b[ 7];
  assign t39 = a[ 6] & b[ 6];
  assign t40 = a[ 6] & b[ 4];
  assign t41 = a[ 6] & b[ 5];
  assign t42 = a[ 4] & b[ 6];
  assign t43 = a[ 5] & b[ 6];
  assign t44 = a[ 5] & b[ 5];
  assign t45 = a[ 5] & b[ 4];
  assign t46 = a[ 4] & b[ 5];
  assign t47 = a[ 4] & b[ 4];
  assign t48 = a[ 3] & b[ 3];
  assign t49 = a[ 3] & b[ 0];
  assign t50 = a[ 3] & b[ 1];
  assign t51 = a[ 3] & b[ 2];
  assign t52 = a[ 0] & b[ 3];
  assign t53 = a[ 1] & b[ 3];
  assign t54 = a[ 2] & b[ 3];
  assign t55 = a[ 2] & b[ 2];
  assign t56 = a[ 2] & b[ 0];
  assign t57 = a[ 2] & b[ 1];
  assign t58 = a[ 0] & b[ 2];
  assign t59 = a[ 1] & b[ 2];
  assign t60 = a[ 1] & b[ 1];
  assign t61 = a[ 1] & b[ 0];
  assign t62 = a[ 0] & b[ 1];
  assign  z0 = a[ 0] & b[ 0];
  assign t63 = b[ 8] ^ b[12];
  assign t64 = b[ 9] ^ b[13];
  assign t65 = b[10] ^ b[14];
  assign t66 = b[11] ^ b[15];
  assign t67 = a[ 8] ^ a[12];
  assign t68 = a[ 9] ^ a[13];
  assign t69 = a[10] ^ a[14];
  assign t70 = a[11] ^ a[15];
  assign t71 = t70 & t66;
  assign t72 = t70 & t63;
  assign t73 = t70 & t64;
  assign t74 = t70 & t65;
  assign t75 = t67 & t66;
  assign t76 = t68 & t66;
  assign t77 = t69 & t66;
  assign t78 = t69 & t65;
  assign t79 = t69 & t63;
  assign t80 = t69 & t64;
  assign t81 = t67 & t65;
  assign t82 = t68 & t65;
  assign t83 = t68 & t64;
  assign t84 = t68 & t63;
  assign t85 = t67 & t64;
  assign t86 = t67 & t63;
  assign t87 = b[0] ^ b[ 4];
  assign t88 = b[1] ^ b[ 5];
  assign t89 = b[2] ^ b[ 6];
  assign t90 = b[3] ^ b[ 7];
  assign t91 = a[0] ^ a[ 4];
  assign t92 = a[1] ^ a[ 5];
  assign t93 = a[2] ^ a[ 6];
  assign t94 = a[3] ^ a[ 7];
  assign t95 = t94  & t90;
  assign t96 = t94  & t87;
  assign t97 = t94  & t88;
  assign t98 = t94  & t89;
  assign t99 = t91  & t90;

  assign t100 = t92 & t90;
  assign t101 = t93 & t90;
  assign t102 = t93 & t89;
  assign t103 = t93 & t87;
  assign t104 = t93 & t88;
  assign t105 = t91 & t89;
  assign t106 = t92 & t89;
  assign t107 = t92 & t88;
  assign t108 = t92 & t87;
  assign t109 = t91 & t88;
  assign t110 = t91 & t87;
  assign t111 = b[4] ^ b[12];
  assign t112 = b[5] ^ b[13];
  assign t113 = b[6] ^ b[14];
  assign t114 = b[7] ^ b[15];
  assign t115 = b[0] ^ b[ 8];
  assign t116 = b[1] ^ b[ 9];
  assign t117 = b[2] ^ b[10];
  assign t118 = b[3] ^ b[11];
  assign t119 = a[4] ^ a[12];
  assign t120 = a[5] ^ a[13];
  assign t121 = a[6] ^ a[14];
  assign t122 = a[7] ^ a[15];
  assign t123 = a[0] ^ a[ 8];
  assign t124 = a[1] ^ a[ 9];
  assign t125 = a[2] ^ a[10];
  assign t126 = a[3] ^ a[11];
  assign t127 = t126 & t118;
  assign t128 = t126 & t115;
  assign t129 = t126 & t116;
  assign t130 = t126 & t117;
  assign t131 = t123 & t118;
  assign t132 = t124 & t118;
  assign t133 = t125 & t118;
  assign t134 = t125 & t117;
  assign t135 = t125 & t115;
  assign t136 = t125 & t116;
  assign t137 = t123 & t117;
  assign t138 = t124 & t117;
  assign t139 = t124 & t116;
  assign t140 = t124 & t115;
  assign t141 = t123 & t116;
  assign t142 = t123 & t115;
  assign t143 = t122 & t114;
  assign t144 = t122 & t111;
  assign t145 = t122 & t112;
  assign t146 = t122 & t113;
  assign t147 = t119 & t114;
  assign t148 = t120 & t114;
  assign t149 = t121 & t114;
  assign t150 = t121 & t113;
  assign t151 = t121 & t111;
  assign t152 = t121 & t112;
  assign t153 = t119 & t113;
  assign t154 = t120 & t113;
  assign t155 = t120 & t112;
  assign t156 = t120 & t111;
  assign t157 = t119 & t112;
  assign t158 = t119 & t111;
  assign t159 = t115 ^ t111;
  assign t160 = t116 ^ t112;
  assign t161 = t117 ^ t113;
  assign t162 = t118 ^ t114;
  assign t163 = t123 ^ t119;
  assign t164 = t124 ^ t120;
  assign t165 = t125 ^ t121;
  assign t166 = t126 ^ t122;
  assign t167 = t166 & t162;
  assign t168 = t166 & t159;
  assign t169 = t166 & t160;
  assign t170 = t166 & t161;
  assign t171 = t163 & t162;
  assign t172 = t164 & t162;
  assign t173 = t165 & t162;
  assign t174 = t165 & t161;
  assign t175 = t165 & t159;
  assign t176 = t165 & t160;
  assign t177 = t163 & t161;
  assign t178 = t164 & t161;
  assign t179 = t164 & t160;
  assign t180 = t164 & t159;
  assign t181 = t163 & t160;
  assign t182 = t163 & t159;
  assign t183 = t73  ^ t76;
  assign t184 = t97  ^ t100;
  assign t185 = t15  ^ t18;
  assign t186 = t129 ^ t132;
  assign t187 = t134 ^ t158;
  assign t188 = t145 ^ t148;
  assign t189 = t169 ^ t172;
  assign t190 = t2   ^ t5;
  assign t191 = t21  ^ t23;
  assign t192 = t31  ^ t34;
  assign t193 = t37  ^ t39;
  assign t194 = t47  ^ t50;
  assign t195 = t53  ^ t55;
  assign t196 = t183 ^ t78;
  assign t197 = t192 ^ t193;
  assign t198 = t194 ^ t195;
  assign t199 = t184 ^ t102;
  assign t200 = t185 ^ t191;
  assign t201 = t186 ^ t187;
  assign t202 = t188 ^ t150;
  assign t203 = t189 ^ t174;
  assign  z28 = t190 ^ t7;
  assign t204 = t198 ^   z0;
  assign   z4 = t110 ^ t204;
  assign t205 = t200 ^  z28;
  assign  z24 = t196 ^ t205;
  assign t206 = t197 ^ t199;
  assign t207 = t197 ^ t86;
  assign t208 = t202 ^ t205;
  assign  z20 = t207 ^ t208;
  assign t209 = t142 ^ t204;
  assign   z8 = t206 ^ t209;
  assign t210 = t196 ^ t198;
  assign t211 = t201 ^ t206;
  assign t212 = t208 ^ t210;
  assign t213 = t211 ^ t212;
  assign t214 = t200 ^ t201;
  assign t215 = t110 ^ t182;
  assign t216 = t209 ^ t214;
  assign t217 = t215 ^ t207;
  assign  z12 = t217 ^ t216;
  assign  z16 = t213 ^ t203;
  assign t218 = t74  ^ t77;
  assign t219 = t84  ^ t85;
  assign t220 = t13  ^ t14;
  assign t221 = t98  ^ t101;
  assign t222 = t108 ^ t109;
  assign t223 = t130 ^ t133;
  assign t224 = t140 ^ t141;
  assign t225 = t146 ^ t149;
  assign t226 = t156 ^ t157;
  assign t227 = t170 ^ t173;
  assign t228 = t19  ^ t22;
  assign t229 = t180 ^ t181;
  assign t230 = t29  ^ t30;
  assign  z29 = t3   ^ t6;
  assign t231 = t35  ^ t38;
  assign t232 = t45  ^ t46;
  assign t233 = t51  ^ t54;
  assign   z1 = t61  ^ t62;
  assign t234 = t228 ^ t220;
  assign t235 = t230 ^ t231;
  assign t236 = t232 ^ t233;
  assign t237 = t223 ^ t226;
  assign t238 =  z29 ^ t234;
  assign  z25 = t218 ^ t238;
  assign t239 =   z1 ^ t236;
  assign   z5 = t222 ^ t239;
  assign t240 = t219 ^ t235;
  assign t241 = t235 ^ t221;
  assign t242 = t224 ^ t239;
  assign   z9 = t241 ^ t242;
  assign t243 = t225 ^ t238;
  assign  z21 = t240 ^ t243;
  assign t244 = t218 ^ t236;
  assign t245 = t237 ^ t241;
  assign t246 = t243 ^ t244;
  assign t247 = t245 ^ t227;
  assign t248 = t234 ^ t237;
  assign t249 = t222 ^ t240;
  assign t250 = t242 ^ t248;
  assign t251 = t249 ^ t229;
  assign  z17 = t247 ^ t246;
  assign  z13 = t251 ^ t250;
  assign t252 = t10  ^ t12;
  assign t253 = t79  ^ t81;
  assign t254 = t103 ^ t105;
  assign t255 = t127 ^ t151;
  assign t256 = t135 ^ t137;
  assign t257 = t153 ^ t155;
  assign t258 = t16  ^ t8;
  assign t259 = t175 ^ t177;
  assign t260 = t24  ^ t26;
  assign t261 = t28  ^ t32;
  assign t262 = t40  ^ t42;
  assign t263 = t44  ^ t48;
  assign t264 = t56  ^ t58;
  assign t265 = t252 ^ t258;
  assign t266 = t261 ^ t260;
  assign t267 = t262 ^ t263;
  assign   z2 = t264 ^ t60;
  assign t268 = t253 ^ t83;
  assign t269 = t254 ^ t107;
  assign t270 = t255 ^ t257;
  assign t271 = t256 ^ t139;
  assign t272 = t259 ^ t179;
  assign t273 = t265 ^  z30;
  assign  z26 = t71  ^ t273;
  assign t274 = t267 ^   z2;
  assign   z6 = t269 ^ t274;
  assign t275 = t266 ^ t268;
  assign t276 = t266 ^ t95 ;
  assign t277 = t271 ^ t274;
  assign  z10 = t276 ^ t277;
  assign t278 = t143 ^ t273;
  assign  z22 = t275 ^ t278;
  assign t279 = t265 ^ t269;
  assign t280 = t270 ^ t275;
  assign t281 = t277 ^ t279;
  assign t282 = t280 ^ t281;
  assign t283 = t267 ^ t270;
  assign t284 = t71  ^ t167;
  assign t285 = t278 ^ t283;
  assign t286 = t284 ^ t276;
  assign  z14 = t282 ^ t272;
  assign  z18 = t286 ^ t285;
  assign t287 = t9   ^ t11;
  assign t288 = t72  ^ t75;
  assign t289 = t80  ^ t82;
  assign t290 = t96  ^ t99;
  assign t291 = t104 ^ t106;
  assign t292 = t1   ^ t4;
  assign t293 = t128 ^ t131;
  assign t294 = t136 ^ t138;
  assign t295 = t144 ^ t147;
  assign t296 = t152 ^ t154;
  assign t297 = t17  ^ t20;
  assign t298 = t168 ^ t171;
  assign t299 = t176 ^ t178;
  assign t300 = t25  ^ t27;
  assign t301 = t33  ^ t36;
  assign t302 = t41  ^ t43;
  assign t303 = t49  ^ t52;
  assign t304 = t57  ^ t59;
  assign  z27 = t287 ^ t292;
  assign t305 = t296 ^ t295;
  assign t306 = t297 ^ t300;
  assign t307 = t298 ^ t299;
  assign t308 = t301 ^ t302;
  assign   z3 = t303 ^ t304;
  assign t309 = t288 ^ t289;
  assign t310 = t290 ^ t291;
  assign t311 = t293 ^ t294;
  assign t312 =  z27 ^ t306;
  assign  z23 = t309 ^ t312;
  assign t313 = t308 ^   z3;
  assign   z7 = t310 ^ t313;
  assign t314 = t305 ^ t308;
  assign  z19 = t312 ^ t314;
  assign t315 = t306 ^ t311;
  assign  z11 = t313 ^ t315;
  assign t316 = t305 ^ t311;
  assign t317 =  z23 ^   z7;
  assign t318 = t316 ^ t307;
  assign  z15 = t318 ^ t317;

  assign r = {1'b0,z30,z29,z28,z27,z26,z25,z24,z23,z22,z21,z20,z19,z18,z17,z16,
               z15,z14,z13,z12,z11,z10, z9, z8, z7, z6, z5, z4, z3, z2, z1,z0};
endmodule
