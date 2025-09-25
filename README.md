# PythonEnvBuilder
基于bat的python环境部署工具。

# 使用方法：
下载[py部署.bat](https://github.com/E5C8F/PythonEnvBuilder/raw/refs/heads/main/py部署.bat)并执行。py将会部署到脚本工作目录。内置多个py、pip下载源，如果脚本执行速度太慢可以编辑更改下载源，或更换网络环境。

# 脚本逻辑流程
```
═══════════════════════════════════════════════════════════════
                    PYTHON环境自动部署工具 - 详细执行流程图
═══════════════════════════════════════════════════════════════

【主程序开始】
├─ 阶段1: 环境初始化
│   ├─ 1.1 启用延迟变量扩展 (setlocal enabledelayedexpansion)
│   ├─ 1.2 设置UTF-8代码页 (chcp 65001)
│   ├─ 1.3 编码兼容性检测
│   │   └─ 动态检测系统编码支持，必要时回退到GBK (chcp 936)
│   ├─ 1.4 设置工作目录到脚本所在路径 (cd /d "%~dp0")
│   └─ 1.5 设置窗口标题 ("Python环境自动部署工具")
│
├─ 阶段2: 资源配置
│   ├─ 2.1 Python下载源配置 (阿里云镜像)
│   │   └─ set "python=https://mirrors.aliyun.com/python-release/windows/python-3.13.7-embed-amd64.zip"
│   ├─ 2.2 get-pip.py下载源配置 (GitHub镜像)
│   │   └─ set "get-pip=https://gh.xxooo.cf/https://github.com/pypa/get-pip/raw/refs/heads/main/public/get-pip.py"
│   └─ 2.3 PyPI镜像源配置 (中科大镜像)
│       └─ set "PIP_INDEX_URL=https://pypi.mirrors.ustc.edu.cn/simple/"
│
├─ 阶段3: 权限检查 (已注释)
│   └─ 3.1 管理员权限检测和提权逻辑 (net session检查)
│
├─ 阶段4: 调用部署子程序
│   └─ call :install_python "%python%" "%get-pip%"
│       ├─ 参数1: Python压缩包URL
│       └─ 参数2: get-pip.py URL
│
├─ 阶段5: 结果处理
│   ├─ 5.1 成功路径 (errorlevel=0)
│   │   └─ 设置标题"Python环境就绪 - cmd"
│   └─ 5.2 失败路径 (errorlevel≠0)
│       ├─ 显示错误信息
│       ├─ 显示错误码说明表
│       └─ 显示分隔线
│
└─ 阶段6: 环境启动
    ├─ 启动新CMD窗口 (cmd /k)
    ├─ 暂停 (pause)
    └─ 退出 (exit)

═══════════════════════════════════════════════════════════════
                    INSTALL_PYTHON 子程序详细流程
═══════════════════════════════════════════════════════════════

【子程序开始】:install_python
├─ 步骤1: 环境变量预设
│   └─ set "PATH=%cd%\%~n1;%cd%\%~n1\Scripts;%PATH%"
│       ├─ Python主目录: %cd%\%~n1
│       └─ Python脚本目录: %cd%\%~n1\Scripts
│
├─ 步骤2: 环境就绪检测 (快速路径)
│   └─ 执行: "%cd%\%~n1\python.exe" -m pip --version >nul 2>&1
│       ├─ [成功] 环境已就绪 → 直接返回0
│       └─ [失败] 进入部署流程
│
├─ 步骤3: 快速部署尝试 (静默模式)
│   └─ 条件: if exist "%cd%\%~nx1" if exist "%cd%\%~nx2"
│       ├─ [条件满足] 执行快速部署
│       │   ├─ 3.1 解压Python: powershell Expand-Archive
│       │   ├─ 3.2 安装pip: "%cd%\%~n1\python.exe" "%cd%\%~nx2"
│       │   ├─ 3.3 配置._pth文件: echo import site>>python*._pth
│       │   ├─ 3.4 依赖包处理 (如果requirements.txt存在)
│       │   │   ├─ 3.4.1 优先离线安装
│       │   │   │   └─ pip install --no-index --find-links="离线包"
│       │   │   ├─ 3.4.2 下载依赖包 (离线安装失败时)
│       │   │   │   └─ pip download -d "离线包"
│       │   │   └─ 3.4.3 混合安装 (最终回退)
│       │   │       └─ pip install --find-links=./离线包
│       │   ├─ 3.5 验证部署: pip --version检测
│       │   ├─ 3.6 输出成功信息
│       │   └─ 3.7 返回0 (成功)
│       └─ [条件不满足/快速部署失败] 转入正常部署流程
│
├─ 步骤4: 正常部署流程 - Python检测
│   └─ 执行: "%cd%\%~n1\python.exe" --version >nul 2>&1
│       ├─ [成功] Python已存在 → 跳过Python部署
│       └─ [失败] 部署Python环境
│           ├─ 4.1 清理旧目录: rd /S /Q "%cd%\%~n1"
│           ├─ 4.2 下载Python压缩包
│           │   └─ powershell WebClient.DownloadFile()
│           │       ├─ [成功] 进入解压流程
│           │       └─ [失败] 返回错误码2
│           ├─ 4.3 解压Python
│           │   └─ powershell Expand-Archive
│           │       ├─ [成功] 输出部署完成信息
│           │       └─ [失败] 返回错误码1
│           └─ 4.4 输出分隔线
│
├─ 步骤5: 正常部署流程 - PIP部署
│   ├─ 5.1 输出分隔线和状态信息
│   ├─ 5.2 下载get-pip.py
│   │   └─ powershell WebClient.DownloadFile()
│   │       ├─ [成功] 进入PIP安装
│   │       └─ [失败] 返回错误码5
│   ├─ 5.3 安装pip模块
│   │   └─ 执行: "%cd%\%~n1\python.exe" "%cd%\%~nx2"
│   │       ├─ [成功] 进入PTH文件配置
│   │       └─ [失败] 返回错误码4
│   ├─ 5.4 配置._pth文件
│   │   └─ for循环处理python*._pth文件
│   │       ├─ [成功] 输出配置完成信息
│   │       └─ [失败] 返回错误码3
│   └─ 5.5 输出分隔线
│
├─ 步骤6: 正常部署流程 - 依赖包部署
│   └─ 条件: if exist "%cd%\requirements.txt"
│       ├─ [存在] 执行依赖包安装
│       │   ├─ 6.1 三级回退安装策略
│       │   │   ├─ 策略1: 纯离线安装 (--no-index)
│       │   │   ├─ 策略2: 下载依赖包 (download -d)
│       │   │   └─ 策略3: 混合安装 (优先离线，失败在线)
│       │   ├─ [成功] 继续执行
│       │   └─ [失败] 返回错误码6
│       └─ [不存在] 跳过依赖安装
│
└─ 步骤7: 子程序结束
    └─ exit /b 0 (成功返回)

═══════════════════════════════════════════════════════════════
                        错误码详细说明
═══════════════════════════════════════════════════════════════

错误码 0: Python环境部署成功
├─ 所有组件部署完成
├─ PATH环境变量已配置
└─ 可正常使用python和pip命令

错误码 1: Python解压失败
├─ 可能原因: 系统兼容性问题
├─ 检查点: Windows版本、压缩软件兼容性
└─ 建议: 使用官方Windows 10/11系统

错误码 2: Python下载失败  
├─ 可能原因: 网络连接问题、镜像源不可用
├─ 检查点: 网络连接、镜像源状态
└─ 建议: 更换下载源或检查网络

错误码 3: PTH文件写入失败
├─ 可能原因: 文件权限问题、路径不存在
├─ 检查点: 文件权限、Python目录结构
└─ 建议: 以管理员权限运行

错误码 4: PIP模块安装失败
├─ 可能原因: 网络问题、PyPI源不可用
├─ 检查点: 网络连接、PyPI镜像状态
└─ 建议: 更换PyPI镜像源

错误码 5: get-pip.py下载失败
├─ 可能原因: 网络问题、GitHub镜像不可用
├─ 检查点: 网络连接、GitHub状态
└─ 建议: 更换get-pip下载源

错误码 6: 依赖项部署失败
├─ 可能原因: 依赖包冲突、网络问题
├─ 检查点: requirements.txt格式、网络连接
└─ 建议: 检查依赖包兼容性

═══════════════════════════════════════════════════════════════
                        部署策略说明
═══════════════════════════════════════════════════════════════

【快速部署策略】
├─ 触发条件: Python压缩包和get-pip.py同时存在
├─ 执行特点: 静默执行，错误转入正常流程
└─ 优势: 大幅减少部署时间

【三级回退依赖安装策略】
├─ 第一级: 纯离线安装 (最快)
│   └─ 参数: --no-index --force-reinstall --find-links="离线包"
├─ 第二级: 下载依赖包 (准备离线环境)
│   └─ 命令: pip download -r requirements.txt -d "离线包"
└─ 第三级: 混合安装 (最终保障)
    └─ 参数: --force-reinstall --find-links=./离线包

【错误处理策略】
├─ 快速部署失败: 静默转入正常流程，用户无感知
├─ 正常流程失败: 明确错误码和提示信息
└─ 依赖安装失败: 三级回退，最大限度保证成功
```

