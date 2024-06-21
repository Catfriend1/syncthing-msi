######################
# FUNCTIONS START    #
######################
function Create-Shortcut {
    param (
        [parameter(Mandatory = $true)] [string] $lnkFullFN,
        [parameter(Mandatory = $true)] [string] $targetFullFN,
        [string] $arguments = "",
        [string] $iconLocation = "",
        [string] $workingDirectory = ($ENV:SystemRoot + "\System32"), 
        [int] $windowStyle = 0                                           # 0: normal, 7:minimized
    )
    #
    $shortcut = (New-Object -COM WScript.Shell).CreateShortcut($lnkFullFN)
    $shortcut.TargetPath = $targetFullFN
    $shortcut.Arguments = $arguments
    $shortcut.IconLocation = $iconLocation
    $shortcut.WorkingDirectory = $workingDirectory
    $shortcut.WindowStyle = $windowStyle
    $shortcut.Save()
    #
    Return
}
######################
# FUNCTIONS END      #
######################
#
# Consts.
[int] $windowStyleMinimized = 7
#
#
# Runtime Variables.
$startMenuProgramsPath = (${ENV:APPDATA} + "\Microsoft\Windows\Start Menu\Programs")
$runAsWrapperCmd = (${ENV:ProgramFiles} + "\SupportPack\runas_wrapper.cmd")
$shell32Dll = (${ENV:SystemRoot} + "\System32\shell32.dll")
#
#
######################
# MAIN               #
######################
#
# Firefox_runaswrapper
$firefoxBin = (${ENV:ProgramFiles} + "\Mozilla Firefox\firefox.exe")
Create-Shortcut `
        -lnkFullFN ($startMenuProgramsPath + "\Firefox_runaswrapper.lnk") `
        -targetFullFN $runAsWrapperCmd `
        -arguments ('Test "' + $firefoxBin + '"') `
        -iconLocation ($firefoxBin)
#
# Signal_runaswrapper
Create-Shortcut `
        -lnkFullFN ($startMenuProgramsPath + "\Signal_runaswrapper.lnk") `
        -targetFullFN $runAsWrapperCmd `
        -arguments 'Test "C:\Users\Test\AppData\Local\Programs\signal-desktop\Signal.exe"' `
        -iconLocation ($shell32Dll + ",18") `
        -windowStyle $windowStyleMinimized
#
# Telegram_runaswrapper
Create-Shortcut `
        -lnkFullFN ($startMenuProgramsPath + "\Telegram_runaswrapper.lnk") `
        -targetFullFN $runAsWrapperCmd `
        -arguments 'Test "C:\Users\test\AppData\Roaming\Telegram Desktop\Telegram.exe"' `
        -iconLocation ($shell32Dll + ",18") `
        -windowStyle $windowStyleMinimized
#
Exit 0
