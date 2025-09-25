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





call :install_python "%python%" "%get-pip%" && (title Python环境就绪 - cmd) || (echo python部署失败，失败原因详见报错（如果有）。返回码=%errorlevel%。& echo "返回码：0=Python环境部署成功。1=python解压失败。2=下载python失败。3=python*._pth文件写入失败。4=pip模块安装失败。5=下载get-pip.py失败。6=依赖项部署失败。" & echo ————————————————————)

cmd /k
pause
exit
rem 通俗易懂流程图（Mermaid语法格式）：
rem flowchart TD
rem     A[开始] --> B[设置代码页和变量]
rem     B --> C[设置标题]
rem     C --> D[设置下载地址和加速源]
rem     D --> E[调用 install_python 子程序]

rem     subgraph Sub [install_python 子程序]
rem         direction TB
rem         S0[子程序开始] --> S1[设置PATH环境变量]
rem         S1 --> C0{检查 pip --version?}

rem         C0 -- 成功 --> S21[部署成功]
rem         S21 --> Ret0[返回 0]

rem         C0 -- 失败 --> C1{检查Python压缩包和<br>get-pip.py是否存在?}
        
rem         C1 -- 都存在 --> F0[执行快速部署]
rem         F0 --> F1[解压Python]
rem         F1 --> F2[运行get-pip.py安装pip]
rem         F2 --> F3[修改._pth文件]
rem         F3 --> F4[检查requirements.txt]
rem         F4 --> F5[安装依赖包]
rem         F5 --> F6{验证 pip --version?}
rem         F6 -- 成功 --> F7[输出部署完成信息]
rem         F7 --> Ret0
rem         F6 -- 失败 --> N0[静默转入正常部署]

rem         C1 -- 文件不全 --> N0

rem         N0 --> C2{检查 python.exe --version?}
rem         C2 -- 存在 --> N3
rem         C2 -- 不存在/失败 --> N1[下载并解压Python]
rem         N1 --> N2{下载解压成功?}
rem         N2 -- 成功 --> N3[输出“Python部署完成”]
rem         N2 -- 失败 --> Ret2[返回错误码 1 或 2]

rem         N3 --> N4[下载get-pip.py]
rem         N4 --> N5{下载成功?}
rem         N5 -- 失败 --> Ret5[返回错误码 5]
rem         N5 -- 成功 --> N6[安装pip并修改._pth文件]
rem         N6 --> N7{安装修改成功?}
rem         N7 -- 失败 --> Ret3[返回错误码 3 或 4]
rem         N7 -- 成功 --> N8[输出“pip模块部署完成”]

rem         N8 --> C3{requirements.txt<br>是否存在?}
rem         C3 -- 不存在 --> Ret0
rem         C3 -- 存在 --> N9[安装依赖包<br>（优先离线，次之在线）]
rem         N9 --> N10{安装成功?}
rem         N10 -- 成功 --> Ret0
rem         N10 -- 失败 --> Ret6[返回错误码 6]
rem     end

rem     E --> Sub

rem     Ret0 --> MainC0{主程序: 返回码=0?}
rem     Ret2 --> MainC0
rem     Ret3 --> MainC0
rem     Ret5 --> MainC0
rem     Ret6 --> MainC0

rem     MainC0 -- 是/0 --> M1[设置标题“Python环境就绪”]
rem     MainC0 -- 否/非0 --> M2[显示相应错误信息]
rem     M1 --> M3[启动新的CMD窗口]
rem     M2 --> M3
rem     M3 --> Z[结束]


:install_python
rem 参数一：python的zip版本下载链接。不支持exe和其他版本。
rem 参数二：get-pip.py下载链接。
rem 返回码：0=Python环境部署成功。1=python解压失败。2=下载python失败。3=python*._pth文件写入失败。4=pip模块安装失败。5=下载get-pip.py失败。6=依赖项部署失败。
set "PATH=%cd%\%~n1;%cd%\%~n1\Scripts;%PATH%"
"%cd%\%~n1\python.exe" -m pip --version >nul 2>&1 || (
	(if exist "%cd%\%~nx1" if exist "%cd%\%~nx2" ((powershell -Command "Expand-Archive -Path "%cd%\%~nx1" -DestinationPath "%cd%\%~n1" -Force" && "%cd%\%~n1\python.exe" "%cd%\%~nx2" && for %%f in ("%cd%\%~n1\python*._pth") do echo import site>>"%%f" && (if exist "%cd%\requirements.txt" ("%cd%\%~n1\python.exe" -m pip install --no-index --force-reinstall --find-links="%cd%\离线包" -r requirements.txt 2>nul || "%cd%\%~n1\python.exe" -m pip download -r requirements.txt -d "%cd%\离线包" || "%cd%\%~n1\python.exe" -m pip install --force-reinstall --find-links=./离线包 -r requirements.txt))) 2>nul && "%cd%\%~n1\python.exe" -m pip --version >nul 2>&1 && echo Python环境部署完成。&& echo ————————————————————) && exit /b 0)

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
	"%cd%\%~n1\python.exe" -m pip install --no-index --force-reinstall --find-links="%cd%\离线包" -r requirements.txt 2>nul || "%cd%\%~n1\python.exe" -m pip download -r requirements.txt -d "%cd%\离线包" || "%cd%\%~n1\python.exe" -m pip install --force-reinstall --find-links=./离线包 -r requirements.txt || echo         依赖项部署失败，请注意是否是网络问题？或尝试更改PyPI源源？失败原因详见报错（如果有）。 && exit /b 6
	)
)









rem python.exe -m pip freeze --all > requirements.txt
rem python.exe -m pip download pip setuptools wheel -d ./离线包
rem python.exe -m pip download -r requirements.txt -d ./离线包 -i https://mirrors.aliyun.com/pypi/simple
rem python.exe -m pip install --no-index --force-reinstall --find-links=./离线包 -r requirements.txt
rem python.exe -m pip install -r requirements.txt --upgrade


exit /b 0

