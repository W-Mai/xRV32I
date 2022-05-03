# Copyright (c) 2022 W-Mai
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# 转换HSL到RGB
# 公式来源于 http://www.easyrgb.com/en/math.php


def hsl_to_rgb(H, S, L):
    def Hue_2_RGB(v1, v2, vH):
        if vH < 0: vH += 1
        if vH > 1: vH -= 1
        if 6 * vH < 1: return v1 + (v2 - v1) * 6 * vH
        if 2 * vH < 1: return v2
        if 3 * vH < 2: return v1 + (v2 - v1) * ((2 / 3) - vH) * 6
        return v1

    if S == 0:
        R = L * 255
        G = L * 255
        B = L * 255
    else:
        if L < 0.5:
            var_2 = L * (1 + S)
        else:
            var_2 = (L + S) - (S * L)

        var_1 = 2 * L - var_2

        R = 255 * Hue_2_RGB(var_1, var_2, H + (1 / 3))
        G = 255 * Hue_2_RGB(var_1, var_2, H)
        B = 255 * Hue_2_RGB(var_1, var_2, H - (1 / 3))
    return int(R), int(G), int(B)


def color_hex(r, g, b):
    return '#%02x%02x%02x' % (r, g, b)
