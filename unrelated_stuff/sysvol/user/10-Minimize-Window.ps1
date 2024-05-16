Add-Type -TypeDefinition @"
	using System;
	using System.Runtime.InteropServices;

	public class WinApi {
		[DllImport("user32.dll")]
		public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
		[DllImport("kernel32.dll")]
		public static extern IntPtr GetConsoleWindow();
	}
"@
#
$consoleHandle = [WinApi]::GetConsoleWindow()
#
# Minimize window
[WinApi]::ShowWindow($consoleHandle, 2)
#
Exit 0
