ClamWin Portable Launcher
=========================

Copyright (C) 2004-2008 John T. Haller of PortableApps.com

Website: http://PortableApps.com/ClamWinPortable

This software is OSI Certified Open Source Software.
OSI Certified is a certification mark of the Open Source Initiative.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.


ABOUT CLAMWIN PORTABLE
======================
The ClamWin Portable Launcher allows you to run ClamWin from a removable drive whose letter changes as you move it to another computer.  It allows you to split the program directory from your profiles directory without hand editing any files.  The program can be entirely self-contained on the drive and then used on any Windows computer.


LICENSE
=======
This code is released under the GPL.  The full code is included with this package as ClamWinPortable.nsi.


INSTALLATION / DIRECTORY STRUCTURE
==================================
By default, the program expects this directory structure:

-\ <--- Directory with ClamWinPortable.exe
  +\App\
    +\clamwin\
  +\Data\
    +\db\
    +\log\
    +\quarantine\

It can be used in other directory configurations by including the ClamWinPortable.ini file in the same directory as ClamWinPortable.exe and configuring it as details in the INI file section below.


ClamWinPortable.INI CONFIGURATION
=================================
The ClamWin Portable Launcher will look for an ini file called ClamWinPortable.ini.  If you are happy with the default options, it is not necessary, though.  The INI file is formatted as follows:

[ClamWinPortable]
ClamWinDirectory=App\clamwin\bin
SettingsDirectory=Data\settings
DBDirectory=Data\db
LogDirectory=Data\log
QuarantineDirectory=Data\quarantine
AdditionalParameters=
WaitForClamWin=false
ClamWinExecutable=ClamWin.exe
ScanExecutable=clamscan.exe
UpdateExecutable=freshclam.exe
DisableSplashScreen=false

The ClamWinDirectory, DBDirectory, LogDirectory, SettingsDirectory and QuarantineDirectory entries should be set to the *relative* path to the appropriate directories from the current directory.  All must be a subdirectory (or multiple subdirectories) of the directory containing ClamWinPortable.exe.  The default entries for these are described in the installation section above.

The AdditionalParameters entry allows you to pass additional commandline parameter entries to ClamWin.exe.  Whatever you enter here will be appended to the call to gaim.exe.

The WaitForClamWin entry allows you to set the ClamWin Portable Launcher to wait for ClamWin to close before it closes.  This option is mainly of use when ClamWin.exe is called by another program that awaits it's conclusion to perform a task.

The ClamWinExecutable, ScanExecutable and UpdateExecutable entries allows you to set the ClamWin Portable Launcher to use alternate EXEs call to launch ClamWin.  This is helpful if you are using a machine that is set to deny ClamWin.exe, etc from running.  You'll need to rename the ClamWin.exe file and then enter the name you gave it on the clamwinexecutable= line of the INI.