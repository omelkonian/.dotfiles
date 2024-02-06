# Source: https://gist.github.com/egel/b7beba6f962110596660
import sublime_plugin
import ctypes
import time

TARGET_CLASS_NAME = "#32770"

class DialogBoxKiller(sublime_plugin.EventListener):

    def close_dialog_boxes(self):
        EnumWindowsProc = ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.POINTER(ctypes.c_int), ctypes.POINTER(ctypes.c_int))
        
        def get_window_class_name(hwnd):
            buff = ctypes.create_unicode_buffer(256)  # Assuming class name won't be longer than 256 characters
            ctypes.windll.user32.GetClassNameW(hwnd, buff, len(buff))
            return buff.value
        
        def enum_windows_callback(hwnd, lparam):
            class_name = get_window_class_name(hwnd)
            if class_name == TARGET_CLASS_NAME:
                ctypes.windll.user32.SendMessageW(hwnd, 0x0010, 0, 0)  # 0x0010 is WM_CLOSE
            return True

        ctypes.windll.user32.EnumWindows(EnumWindowsProc(enum_windows_callback), 0)
        
    def on_pre_save_async(self, *args):
        time.sleep(0.1)  # Brief delay to ensure dialog has time to appear if it does
        self.close_dialog_boxes()    
