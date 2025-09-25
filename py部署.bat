@echo off & setlocal enabledelayedexpansion & chcp 65001 >nul 2>&1
set "a=����a" & for /f "usebackq delims=" %%a in (`echo !a^:^~2^,1!`) do (if not "%%~a"=="a" chcp 936 >nul 2>&1) & set "a="
cd /d "%~dp0"
title Python�����Զ����𹤾�

rem set /p=<nul

rem net session >nul 2>&1 || (PowerShell -Command Start-Process '%~f0' -ArgumentList '\"%*\"' -Verb RunAs -WindowStyle Hidden && exit /b) || TIMEOUT /T 99999 /NOBREAK >nul 2>&1



rem ����Ϊpython-3.13.7�ġ��ٷ�ѹ���桢����ѹ���桢�ٷ���Я�桢�����Я�桿�����ص�ַ��
rem set "python=https://www.python.org/ftp/python/3.13.7/python-3.13.7-amd64.zip"
rem set "python=https://www.python.org/ftp/python/3.13.7/python-3.13.7-embed-amd64.zip"
rem set "python=https://repo.huaweicloud.com/python/3.13.7/python-3.13.7-amd64.zip"
rem set "python=https://repo.huaweicloud.com/python/3.13.7/python-3.13.7-embed-amd64.zip"
set "python=https://mirrors.aliyun.com/python-release/windows/python-3.13.7-embed-amd64.zip"


rem ����Ϊget-pip.py�ġ��ٷ��������ٷ�github��CDN���ٹٷ�github��������ٹٷ�github�������ص�ַ��
rem set "get-pip=https://bootstrap.pypa.io/get-pip.py"
rem set "get-pip=https://github.com/pypa/get-pip/raw/refs/heads/main/public/get-pip.py"
rem set "get-pip=https://cdn.jsdelivr.net/gh/pypa/get-pip@main/public/get-pip.py"
set "get-pip=https://gh.xxooo.cf/https://github.com/pypa/get-pip/raw/refs/heads/main/public/get-pip.py"


rem ����ΪPyPI����Դ���廪����Դ�������Ƽ���Դ����Ϊ�Ƽ���Դ���������Դ���пƴ����Դ��
rem set "PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple/"
rem set "PIP_INDEX_URL=https://mirrors.aliyun.com/pypi/simple/"
rem set "PIP_INDEX_URL=https://repo.huaweicloud.com/repository/pypi/simple/"
rem set "PIP_INDEX_URL=https://pypi.douban.com/simple/"
set "PIP_INDEX_URL=https://pypi.mirrors.ustc.edu.cn/simple/"





call :install_python "%python%" "%get-pip%" && (title Python�������� - cmd) || (echo python����ʧ�ܣ�ʧ��ԭ�������������У���������=%errorlevel%��& echo "�����룺0=Python��������ɹ���1=python��ѹʧ�ܡ�2=����pythonʧ�ܡ�3=python*._pth�ļ�д��ʧ�ܡ�4=pipģ�鰲װʧ�ܡ�5=����get-pip.pyʧ�ܡ�6=�������ʧ�ܡ�" & echo ����������������������������������������)

cmd /k
pause
exit
rem ͨ���׶�����ͼ��Mermaid�﷨��ʽ����
rem flowchart TD
rem     A[��ʼ] --> B[���ô���ҳ�ͱ���]
rem     B --> C[���ñ���]
rem     C --> D[�������ص�ַ�ͼ���Դ]
rem     D --> E[���� install_python �ӳ���]

rem     subgraph Sub [install_python �ӳ���]
rem         direction TB
rem         S0[�ӳ���ʼ] --> S1[����PATH��������]
rem         S1 --> C0{��� pip --version?}

rem         C0 -- �ɹ� --> S21[����ɹ�]
rem         S21 --> Ret0[���� 0]

rem         C0 -- ʧ�� --> C1{���Pythonѹ������<br>get-pip.py�Ƿ����?}
        
rem         C1 -- ������ --> F0[ִ�п��ٲ���]
rem         F0 --> F1[��ѹPython]
rem         F1 --> F2[����get-pip.py��װpip]
rem         F2 --> F3[�޸�._pth�ļ�]
rem         F3 --> F4[���requirements.txt]
rem         F4 --> F5[��װ������]
rem         F5 --> F6{��֤ pip --version?}
rem         F6 -- �ɹ� --> F7[������������Ϣ]
rem         F7 --> Ret0
rem         F6 -- ʧ�� --> N0[��Ĭת����������]

rem         C1 -- �ļ���ȫ --> N0

rem         N0 --> C2{��� python.exe --version?}
rem         C2 -- ���� --> N3
rem         C2 -- ������/ʧ�� --> N1[���ز���ѹPython]
rem         N1 --> N2{���ؽ�ѹ�ɹ�?}
rem         N2 -- �ɹ� --> N3[�����Python������ɡ�]
rem         N2 -- ʧ�� --> Ret2[���ش����� 1 �� 2]

rem         N3 --> N4[����get-pip.py]
rem         N4 --> N5{���سɹ�?}
rem         N5 -- ʧ�� --> Ret5[���ش����� 5]
rem         N5 -- �ɹ� --> N6[��װpip���޸�._pth�ļ�]
rem         N6 --> N7{��װ�޸ĳɹ�?}
rem         N7 -- ʧ�� --> Ret3[���ش����� 3 �� 4]
rem         N7 -- �ɹ� --> N8[�����pipģ�鲿����ɡ�]

rem         N8 --> C3{requirements.txt<br>�Ƿ����?}
rem         C3 -- ������ --> Ret0
rem         C3 -- ���� --> N9[��װ������<br>���������ߣ���֮���ߣ�]
rem         N9 --> N10{��װ�ɹ�?}
rem         N10 -- �ɹ� --> Ret0
rem         N10 -- ʧ�� --> Ret6[���ش����� 6]
rem     end

rem     E --> Sub

rem     Ret0 --> MainC0{������: ������=0?}
rem     Ret2 --> MainC0
rem     Ret3 --> MainC0
rem     Ret5 --> MainC0
rem     Ret6 --> MainC0

rem     MainC0 -- ��/0 --> M1[���ñ��⡰Python����������]
rem     MainC0 -- ��/��0 --> M2[��ʾ��Ӧ������Ϣ]
rem     M1 --> M3[�����µ�CMD����]
rem     M2 --> M3
rem     M3 --> Z[����]


:install_python
rem ����һ��python��zip�汾�������ӡ���֧��exe�������汾��
rem ��������get-pip.py�������ӡ�
rem �����룺0=Python��������ɹ���1=python��ѹʧ�ܡ�2=����pythonʧ�ܡ�3=python*._pth�ļ�д��ʧ�ܡ�4=pipģ�鰲װʧ�ܡ�5=����get-pip.pyʧ�ܡ�6=�������ʧ�ܡ�
set "PATH=%cd%\%~n1;%cd%\%~n1\Scripts;%PATH%"
"%cd%\%~n1\python.exe" -m pip --version >nul 2>&1 || (
	(if exist "%cd%\%~nx1" if exist "%cd%\%~nx2" ((powershell -Command "Expand-Archive -Path "%cd%\%~nx1" -DestinationPath "%cd%\%~n1" -Force" && "%cd%\%~n1\python.exe" "%cd%\%~nx2" && for %%f in ("%cd%\%~n1\python*._pth") do echo import site>>"%%f" && (if exist "%cd%\requirements.txt" ("%cd%\%~n1\python.exe" -m pip install --no-index --force-reinstall --find-links="%cd%\���߰�" -r requirements.txt 2>nul || "%cd%\%~n1\python.exe" -m pip download -r requirements.txt -d "%cd%\���߰�" || "%cd%\%~n1\python.exe" -m pip install --force-reinstall --find-links=./���߰� -r requirements.txt))) 2>nul && "%cd%\%~n1\python.exe" -m pip --version >nul 2>&1 && echo Python����������ɡ�&& echo ����������������������������������������) && exit /b 0)

    "%cd%\%~n1\python.exe" --version >nul 2>&1 || (
		echo ����������������������������������������
		echo     ��⵽%~n1δ�������ڽ��в��𡭡�
        if exist "%cd%\%~n1" rd /S /Q "%cd%\%~n1" >nul 2>&1
		(
			powershell -Command "[System.Net.WebClient]::new().DownloadFile('%~1', '%cd%\%~nx1')" && (
				powershell -Command "Expand-Archive -Path "%cd%\%~nx1" -DestinationPath "%cd%\%~n1" -Force" && (
					echo         %~n1 ������ɡ�
				) || echo         python��ѹʧ�ܣ���ע���Ƿ�Ϊ�ٷ���ʽ��windows10��windows11ϵͳ��ʧ��ԭ�������������У��� && exit /b 1
			) || echo         ����pythonʧ�ܣ���ע���Ƿ����������⣿���Ը���%~n1����Դ��ʧ��ԭ�������������У��� && exit /b 2
		)
    )
	echo ����������������������������������������
	echo     ��⵽%~n1��pipģ��δ�������ڽ��в��𡭡�	
	powershell -Command "[System.Net.WebClient]::new().DownloadFile('%~2', '%cd%\%~nx2')" && (
		"%cd%\%~n1\python.exe" "%cd%\%~nx2" && (
			for %%f in ("%cd%\%~n1\python*._pth") do echo import site>>"%%f" && (
				echo         %~n1��pipģ�鲿����ɡ�
			) || echo         "%cd%\%~n1\python*._pth"�ļ�д��ʧ�ܡ� && exit /b 3
		) || echo         python��pipģ�鰲װʧ�ܣ���ע���Ƿ����������⣿���Ը���PyPIԴ��ʧ��ԭ�������������У��� && exit /b 4
	) || echo         ����get-pip.pyʧ�ܣ���ע���Ƿ����������⣿���Ը���get-pip.py����Դ��ʧ��ԭ�������������У��� && exit /b 5
	echo ����������������������������������������
	if exist "%cd%\requirements.txt" (
rem 	"%cd%\%~n1\python.exe" -m pip freeze --all > "%cd%\requirements.tmp"
rem 	fc /C /N /W "%cd%\requirements.txt" "%cd%\requirements.tmp" >nul 2>&1 || (
	echo         ��⵽%~n1��������δ�������ڽ��в��𡭡�
	"%cd%\%~n1\python.exe" -m pip install --no-index --force-reinstall --find-links="%cd%\���߰�" -r requirements.txt 2>nul || "%cd%\%~n1\python.exe" -m pip download -r requirements.txt -d "%cd%\���߰�" || "%cd%\%~n1\python.exe" -m pip install --force-reinstall --find-links=./���߰� -r requirements.txt || echo         �������ʧ�ܣ���ע���Ƿ����������⣿���Ը���PyPIԴԴ��ʧ��ԭ�������������У��� && exit /b 6
	)
)









rem python.exe -m pip freeze --all > requirements.txt
rem python.exe -m pip download pip setuptools wheel -d ./���߰�
rem python.exe -m pip download -r requirements.txt -d ./���߰� -i https://mirrors.aliyun.com/pypi/simple
rem python.exe -m pip install --no-index --force-reinstall --find-links=./���߰� -r requirements.txt
rem python.exe -m pip install -r requirements.txt --upgrade


exit /b 0

