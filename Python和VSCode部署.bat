@echo off & setlocal enabledelayedexpansion & chcp 65001 >nul 2>&1
set "a=编码a" & for /f "usebackq delims=" %%a in (`echo !a^:^~2^,1!`) do (if not "%%~a"=="a" chcp 936 >nul 2>&1) & set "a="
cd /d "%~dp0"


title Python环境自动部署工具

rem set /p=<nul

rem net session >nul 2>&1 || (PowerShell -Command Start-Process '%~f0' -ArgumentList '\"%*\"' -Verb RunAs -WindowStyle Hidden && exit /b) || TIMEOUT /T 99999 /NOBREAK >nul 2>&1



rem 以下为python-3.13.7的【官方压缩版、镜像压缩版、官方便携版、镜像便携版】的下载地址。
rem set "python=https://www.python.org/ftp/python/3.13.7/python-3.13.7-amd64.zip"
rem set "python=https://www.python.org/ftp/python/3.13.7/python-3.13.7-embed-amd64.zip"
rem set "python=https://repo.huaweicloud.com/python/3.13.7/python-3.13.7-amd64.zip"
rem set "python=https://repo.huaweicloud.com/python/3.13.7/python-3.13.7-embed-amd64.zip"
set "python=https://mirrors.aliyun.com/python-release/windows/python-3.13.7-embed-amd64.zip"


rem 以下为get-pip.py的【官方官网、官方github、CDN加速官方github、镜像加速官方github】的下载地址。
rem set "get-pip=https://bootstrap.pypa.io/get-pip.py"
rem set "get-pip=https://github.com/pypa/get-pip/raw/refs/heads/main/public/get-pip.py"
rem set "get-pip=https://cdn.jsdelivr.net/gh/pypa/get-pip@main/public/get-pip.py"
set "get-pip=https://gh.xxooo.cf/https://github.com/pypa/get-pip/raw/refs/heads/main/public/get-pip.py"


rem 以下为PyPI加速源【清华加速源、阿里云加速源、华为云加速源、豆瓣加速源、中科大加速源】
rem set "PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple/"
rem set "PIP_INDEX_URL=https://mirrors.aliyun.com/pypi/simple/"
rem set "PIP_INDEX_URL=https://repo.huaweicloud.com/repository/pypi/simple/"
rem set "PIP_INDEX_URL=https://pypi.douban.com/simple/"
set "PIP_INDEX_URL=https://pypi.mirrors.ustc.edu.cn/simple/"



rem python.exe -m pip freeze --all > requirements.txt
rem python.exe -m pip download pip setuptools wheel -d ./离线包
rem python.exe -m pip download -r requirements.txt -d ./离线包 -i https://mirrors.aliyun.com/pypi/simple
rem python.exe -m pip install --no-index --force-reinstall --find-links=./离线包 -r requirements.txt
rem python.exe -m pip install -r requirements.txt --upgrade




call :install_python "%python%" "%get-pip%" && (title Python环境就绪 - cmd && echo Python环境自动部署工具 ^[版本 3.13.7^] 保留所有权利) || (echo python部署失败，失败原因详见报错（如果有）。返回码=%errorlevel%。& echo "返回码：0=Python环境部署成功。1=python解压失败。2=下载python失败。3=python*._pth文件写入失败。4=pip模块安装失败。5=下载get-pip.py失败。6=依赖项部署失败。" & echo ————————————————————)




start "" /i "%cd%\VSCode-win32-x64\code.exe" || (
powershell -Command "[System.Net.WebClient]::new().DownloadFile('https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive', '%cd%\VSCode-win32-x64.zip')"
powershell -Command "Expand-Archive -Path "%cd%\VSCode-win32-x64.zip" -DestinationPath "%cd%\VSCode-win32-x64" -Force"
md "%cd%\VSCode-win32-x64\data\tmp"
start "" /i "%cd%\VSCode-win32-x64\code.exe"
)


cmd /k







:install_python
rem 参数一：python的zip版本下载链接。不支持exe和其他版本。
rem 参数二：get-pip.py下载链接。
rem 返回码：0=Python环境部署成功。1=python解压失败。2=下载python失败。3=python*._pth文件写入失败。4=pip模块安装失败。5=下载get-pip.py失败。6=依赖项部署失败。
set "PATH=%cd%\%~n1;%cd%\%~n1\Scripts;%PATH%"
"%cd%\%~n1\python.exe" -m pip --version >nul 2>&1 || (
	(if exist "%cd%\%~nx1" if exist "%cd%\%~nx2" ((powershell -Command "Expand-Archive -Path "%cd%\%~nx1" -DestinationPath "%cd%\%~n1" -Force" && "%cd%\%~n1\python.exe" "%cd%\%~nx2" && for %%f in ("%cd%\%~n1\python*._pth") do echo import site>>"%%f" && (if exist "%cd%\requirements.txt" ("%cd%\%~n1\python.exe" -m pip install --no-index --force-reinstall --find-links="%cd%\离线包" -r requirements.txt 2>nul || ("%cd%\%~n1\python.exe" -m pip download -r requirements.txt -d "%cd%\离线包" && "%cd%\%~n1\python.exe" -m pip install --force-reinstall --find-links="%cd%\离线包" -r requirements.txt)))) 2>nul && "%cd%\%~n1\python.exe" -m pip --version >nul 2>&1 && echo Python环境部署完成。&& echo ————————————————————) && exit /b 0)

    "%cd%\%~n1\python.exe" --version >nul 2>&1 || (
		echo ————————————————————
		echo     检测到%~n1未部署，正在进行部署……
        if exist "%cd%\%~n1" rd /S /Q "%cd%\%~n1" >nul 2>&1
		(
			powershell -Command "[System.Net.WebClient]::new().DownloadFile('%~1', '%cd%\%~nx1')" && (
				powershell -Command "Expand-Archive -Path "%cd%\%~nx1" -DestinationPath "%cd%\%~n1" -Force" && (
					echo         %~n1 部署完成。
				) || echo         python解压失败，请注意是否为官方正式版windows10、windows11系统？失败原因详见报错（如果有）。 && exit /b 1
			) || echo         下载python失败，请注意是否是网络问题？或尝试更改%~n1下载源？失败原因详见报错（如果有）。 && exit /b 2
		)
    )
	echo ————————————————————
	echo     检测到%~n1的pip模块未部署，正在进行部署……	
	powershell -Command "[System.Net.WebClient]::new().DownloadFile('%~2', '%cd%\%~nx2')" && (
		"%cd%\%~n1\python.exe" "%cd%\%~nx2" && (
			for %%f in ("%cd%\%~n1\python*._pth") do echo import site>>"%%f" && (
				echo         %~n1的pip模块部署完成。
			) || echo         "%cd%\%~n1\python*._pth"文件写入失败。 && exit /b 3
		) || echo         python的pip模块安装失败，请注意是否是网络问题？或尝试更改PyPI源？失败原因详见报错（如果有）。 && exit /b 4
	) || echo         下载get-pip.py失败，请注意是否是网络问题？或尝试更改get-pip.py下载源？失败原因详见报错（如果有）。 && exit /b 5
	echo ————————————————————
	if exist "%cd%\requirements.txt" (
rem 	"%cd%\%~n1\python.exe" -m pip freeze --all > "%cd%\requirements.tmp"
rem 	fc /C /N /W "%cd%\requirements.txt" "%cd%\requirements.tmp" >nul 2>&1 || (
	echo         检测到%~n1的依赖项未部署，正在进行部署……
	"%cd%\%~n1\python.exe" -m pip install --no-index --force-reinstall --find-links="%cd%\离线包" -r requirements.txt 2>nul || "%cd%\%~n1\python.exe" -m pip download -r requirements.txt -d "%cd%\离线包" || "%cd%\%~n1\python.exe" -m pip install --force-reinstall --find-links=./离线包 -r requirements.txt || echo         依赖项部署失败，请注意是否是网络问题？或尝试更改PyPI源？失败原因详见报错（如果有）。 && exit /b 6
	)
)

exit /b 0

