#############################################
# File Name: FrameworkDrawer.py
# Author: W-Mai
# Mail: 1341398182@qq.com
# Created Time:  2022-04-27
#############################################
import time

from FrameworkDrawer import FrameworkDrawer

if __name__ == '__main__':
    t0 = time.time()
    fd = FrameworkDrawer(file=__import__('frame_config'), is_model=True)
    fd.draw("schema.svg")
    print("Time:", time.time() - t0)
