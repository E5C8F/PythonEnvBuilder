# PythonEnvBuilder
基于bat的python环境部署工具。

# 使用方法：
下载[py部署.bat](https://github.com/E5C8F/PythonEnvBuilder/raw/refs/heads/main/py部署.bat)并执行。py将会部署到脚本工作目录。内置多个py、pip下载源，如果脚本执行速度太慢可以编辑更改下载源，或更换网络环境。默认使用python-3.13.7-embed-amd64.zip版本，可以自行编辑修改，但请注意此脚本只支持zip版本的python部署。

# 脚本逻辑流程
```
══════════════════════════════════════════════════════════════════════════════
                  PYTHON环境自动部署工具 - 详细执行流程图
══════════════════════════════════════════════════════════════════════════════

【主程序启动阶段】 - 批处理文件开始执行
├─ 第1步: 基础环境配置
│   ├─ 1.1 启用延迟变量扩展: setlocal enabledelayedexpansion
│   │   └─ 目的: 支持动态变量计算和修改
│   ├─ 1.2 设置UTF-8编码: chcp 65001 >nul 2>&1
│   │   ├─ 编码: 65001 (UTF-8)
│   │   └─ 输出重定向: 隐藏命令输出
│   ├─ 1.3 智能编码兼容性检测
│   │   ├─ 设置测试变量: set "a=编码a"
│   │   ├─ 执行编码测试: for /f "usebackq delims=" %%a in (`echo !a^:^~2^,1!`)
│   │   ├─ 条件判断: if not "%%~a"=="a"
│   │   ├─ [条件真] 回退到GBK: chcp 936 >nul 2>&1
│   │   ├─ [条件假] 保持UTF-8
│   │   └─ 清理变量: set "a="
│   ├─ 1.4 设置工作目录: cd /d "%~dp0"
│   │   ├─ %~dp0: 获取批处理文件所在目录的完整路径
│   │   └─ /d 参数: 支持驱动器切换
│   └─ 1.5 设置窗口标题: title Python环境自动部署工具
│
├─ 第2步: 管理员权限检测 (已注释但保留逻辑)
│   ├─ 2.1 权限检查: net session >nul 2>&1
│   │   ├─ [失败] 执行提权操作
│   │   │   ├─ PowerShell提权: Start-Process '%~f0' -Verb RunAs
│   │   │   ├─ 隐藏窗口: -WindowStyle Hidden
│   │   │   ├─ 传递参数: -ArgumentList '\"%*\"'
│   │   │   └─ 退出当前进程: exit /b
│   │   └─ [成功] 继续执行
│   └─ 2.2 超时等待: TIMEOUT /T 99999 /NOBREAK >nul 2>&1
│
├─ 第3步: 资源配置系统
│   ├─ 3.1 Python下载源配置 (多源备用)
│   │   ├─ 官方压缩版: https://www.python.org/ftp/python/3.13.7/python-3.13.7-amd64.zip
│   │   ├─ 官方便携版: https://www.python.org/ftp/python/3.13.7/python-3.13.7-embed-amd64.zip
│   │   ├─ 华为云镜像: https://repo.huaweicloud.com/python/3.13.7/python-3.13.7-amd64.zip
│   │   ├─ 华为云便携版: https://repo.huaweicloud.com/python/3.13.7/python-3.13.7-embed-amd64.zip
│   │   └─ 当前使用: 阿里云便携版: https://mirrors.aliyun.com/python-release/windows/python-3.13.7-embed-amd64.zip
│   ├─ 3.2 get-pip.py下载源配置
│   │   ├─ 官方CDN: https://bootstrap.pypa.io/get-pip.py
│   │   ├─ GitHub原始: https://github.com/pypa/get-pip/raw/refs/heads/main/public/get-pip.py
│   │   ├─ jsDelivr CDN: https://cdn.jsdelivr.net/gh/pypa/get-pip@main/public/get-pip.py
│   │   └─ 当前使用: GitHub镜像加速: https://gh.xxooo.cf/https://github.com/pypa/get-pip/raw/refs/heads/main/public/get-pip.py
│   └─ 3.3 PyPI镜像源配置
│       ├─ 清华大学: https://pypi.tuna.tsinghua.edu.cn/simple/
│       ├─ 阿里云: https://mirrors.aliyun.com/pypi/simple/
│       ├─ 华为云: https://repo.huaweicloud.com/repository/pypi/simple/
│       ├─ 豆瓣: https://pypi.douban.com/simple/
│       └─ 当前使用: 中科大镜像: https://pypi.mirrors.ustc.edu.cn/simple/
│
├─ 第4步: 子程序调用
│   └─ call :install_python "%python%" "%get-pip%"
│       ├─ 调用指令: call :label arg1 arg2
│       ├─ 参数1传递: Python下载URL
│       ├─ 参数2传递: get-pip.py下载URL
│       └─ 等待子程序返回错误码
│
├─ 第5步: 部署结果处理
│   ├─ 5.1 成功处理 (errorlevel == 0)
│   │   └─ 设置就绪标题: title Python环境就绪 - cmd
│   └─ 5.2 失败处理 (errorlevel != 0)
│       ├─ 显示错误信息: echo python部署失败，失败原因详见报错（如果有）。
│       ├─ 显示错误码: echo 返回码=%errorlevel%。
│       ├─ 显示错误码说明表
│       └─ 显示分隔线: echo ————————————————————
│
└─ 第6步: 环境启动与退出
    ├─ 启动新CMD: cmd /k
    │   └─ 特性: 继承当前环境变量，保持会话
    ├─ 用户暂停: pause
    │   └─ 目的: 让用户查看部署结果
    └─ 退出程序: exit
        └─ 确保批处理完全退出

══════════════════════════════════════════════════════════════════════════════
                   INSTALL_PYTHON 子程序 - 深度技术分析
══════════════════════════════════════════════════════════════════════════════

【子程序入口】:install_python
├─ 参数说明:
│   ├─ %1: Python压缩包URL (完整URL路径)
│   ├─ %2: get-pip.py下载URL
│   └─ %~n1: 从URL中提取的文件名（不含扩展名）
│
├─ 阶段1: 环境变量预配置
│   └─ set "PATH=%cd%\%~n1;%cd%\%~n1\Scripts;%PATH%"
│       ├─ 动态路径构建:
│       │   ├─ Python主目录: %cd%\%~n1 (如: C:\project\python-3.13.7-embed-amd64)
│       │   └─ 脚本目录: %cd%\%~n1\Scripts
│       ├─ 路径优先级: 新路径前置，确保使用部署的Python
│       └─ 作用范围: 当前进程及子进程
│
├─ 阶段2: 环境就绪性检测 (快速路径)
│   └─ 执行检测: "%cd%\%~n1\python.exe" -m pip --version >nul 2>&1
│       ├─ 检测逻辑: 通过pip模块版本检查判断环境完整性
│       ├─ 输出处理: >nul 2>&1 隐藏所有输出
│       ├─ [检测成功] 
│       │   ├─ 状态: Python和pip均已就绪
│       │   └─ 动作: 直接返回0，跳过所有部署步骤
│       └─ [检测失败] 
│           ├─ 状态: 需要部署或修复环境
│           └─ 动作: 进入部署判断流程
│
├─ 阶段3: 快速部署判断与执行
│   └─ 条件检查: if exist "%cd%\%~nx1" if exist "%cd%\%~nx2"
│       ├─ %~nx1: Python压缩包文件名 (如: python-3.13.7-embed-amd64.zip)
│       ├─ %~nx2: get-pip.py文件名
│       ├─ [条件满足] 执行快速部署流程
│       │   ├─ 3.1 静默解压: powershell Expand-Archive
│       │   │   ├─ 命令: Expand-Archive -Path "文件" -DestinationPath "目录" -Force
│       │   │   ├─ -Force: 覆盖已存在文件
│       │   │   └─ 错误处理: 静默失败，转入正常流程
│       │   ├─ 3.2 安装pip: "%cd%\%~n1\python.exe" "%cd%\%~nx2"
│       │   │   └─ 使用Python直接执行get-pip.py脚本
│       │   ├─ 3.3 配置._pth文件
│       │   │   ├─ 文件模式: for %%f in ("python*._pth")
│       │   │   ├─ 修改内容: echo import site>>"%%f"
│       │   │   └─ 目的: 启用site模块，支持pip安装的包导入
│       │   ├─ 3.4 依赖包智能安装 (条件: exist "requirements.txt")
│       │   │   ├─ 策略1: 纯离线安装
│       │   │   │   └─ 命令: pip install --no-index --force-reinstall --find-links="%cd%\离线包"
│       │   │   ├─ 策略2: 下载依赖包
│       │   │   │   └─ 命令: pip download -r requirements.txt -d "%cd%\离线包"
│       │   │   ├─ 策略3: 混合安装
│       │   │   │   └─ 命令: pip install --force-reinstall --find-links=./离线包
│       │   │   └─ 错误处理: 2>nul 隐藏错误，继续执行
│       │   ├─ 3.5 最终验证: "%cd%\%~n1\python.exe" -m pip --version >nul 2>&1
│       │   ├─ 3.6 输出成功信息
│       │   ├─ 3.7 返回成功码: exit /b 0
│       │   └─ 关键特性: 任何步骤失败都静默转入正常部署
│       └─ [条件不满足] 直接进入正常部署流程
│
├─ 阶段4: 正常部署流程 - Python环境部署
│   └─ Python存在性检测: "%cd%\%~n1\python.exe" --version >nul 2>&1
│       ├─ [检测成功] Python已存在，跳过部署
│       └─ [检测失败] 执行完整Python部署
│           ├─ 4.1 输出部署信息: echo 检测到%~n1未部署，正在进行部署……
│           ├─ 4.2 清理旧目录: if exist "%cd%\%~n1" rd /S /Q "%cd%\%~n1"
│           │   ├─ /S: 递归删除子目录
│           │   ├─ /Q: 安静模式，不确认
│           │   └─ 目的: 确保干净的安装环境
│           ├─ 4.3 下载Python压缩包
│           │   ├─ 命令: powershell -Command "[System.Net.WebClient]::new().DownloadFile('%~1', '%cd%\%~nx1')"
│           │   ├─ 技术: .NET WebClient类下载
│           │   ├─ [成功] 进入解压步骤
│           │   └─ [失败] 返回错误码2，附带详细错误信息
│           ├─ 4.4 解压Python包
│           │   ├─ 命令: powershell Expand-Archive -Path "%cd%\%~nx1" -DestinationPath "%cd%\%~n1" -Force
│           │   ├─ [成功] 输出完成信息
│           │   └─ [失败] 返回错误码1，检查系统兼容性
│           └─ 4.5 输出分隔线
│
├─ 阶段5: 正常部署流程 - PIP模块部署
│   ├─ 5.1 输出状态信息: echo 检测到%~n1的pip模块未部署，正在进行部署……
│   ├─ 5.2 下载get-pip.py
│   │   ├─ 命令: powershell WebClient.DownloadFile('%~2', '%cd%\%~nx2')
│   │   ├─ [成功] 进入安装步骤
│   │   └─ [失败] 返回错误码5
│   ├─ 5.3 安装pip模块
│   │   ├─ 命令: "%cd%\%~n1\python.exe" "%cd%\%~nx2"
│   │   ├─ 原理: 使用Python执行get-pip.py引导脚本
│   │   ├─ [成功] 进入配置步骤
│   │   └─ [失败] 返回错误码4
│   ├─ 5.4 配置._pth文件
│   │   ├─ 命令: for %%f in ("%cd%\%~n1\python*._pth") do echo import site>>"%%f"
│   │   ├─ 文件通配: python*._pth (如: python313._pth)
│   │   ├─ 修改方式: 追加import site到文件末尾
│   │   ├─ [成功] 输出完成信息
│   │   └─ [失败] 返回错误码3
│   └─ 5.5 输出分隔线
│
├─ 阶段6: 正常部署流程 - 依赖包部署
│   └─ 条件检查: if exist "%cd%\requirements.txt"
│       ├─ [文件存在] 执行依赖部署
│       │   ├─ 6.1 三级回退安装策略
│       │   │   ├─ 第一级: 纯离线安装 (最快)
│       │   │   │   └─ 参数: --no-index --force-reinstall --find-links="%cd%\离线包"
│       │   │   ├─ 第二级: 下载依赖包
│       │   │   │   └─ 命令: pip download -r requirements.txt -d "%cd%\离线包"
│       │   │   └─ 第三级: 混合安装
│       │   │       └─ 参数: --force-reinstall --find-links=./离线包
│       │   ├─ 错误处理: || 操作符实现条件执行
│       │   ├─ [成功] 继续执行
│       │   └─ [失败] 返回错误码6
│       └─ [文件不存在] 跳过依赖安装
│
└─ 阶段7: 子程序退出
    └─ exit /b 0
        ├─ /b 参数: 仅退出子程序，不终止批处理
        └─ 返回码: 0表示成功

══════════════════════════════════════════════════════════════════════════════
                    错误码系统 - 完整技术规范
══════════════════════════════════════════════════════════════════════════════

错误码 0: SUCCESS - Python环境部署成功
├─ 检测标准: pip --version 命令执行成功
├─ 环境状态: 
│   ├─ Python可执行文件就绪
│   ├─ pip包管理器就绪
│   ├─ PATH环境变量已配置
│   └─ 依赖包（如果存在）已安装
└─ 后续动作: 启动新的CMD会话

错误码 1: PYTHON_EXTRACT_FAILED - Python解压失败
├─ 发生阶段: 阶段4.4 - PowerShell解压操作
├─ 可能原因:
│   ├─ 系统PowerShell版本过低
│   ├─ 压缩包文件损坏
│   ├─ 磁盘空间不足
│   ├─ 文件权限限制
│   └─ 防病毒软件拦截
├─ 错误信息: "python解压失败，请注意是否为官方正式版windows10、windows11系统？"
└─ 解决建议: 检查系统兼容性，手动解压测试

错误码 2: PYTHON_DOWNLOAD_FAILED - Python下载失败  
├─ 发生阶段: 阶段4.3 - WebClient下载
├─ 可能原因:
│   ├─ 网络连接故障
│   ├─ 镜像源不可用
│   ├─ DNS解析失败
│   ├─ 防火墙阻挡
│   └─ 磁盘写入权限不足
├─ 错误信息: "下载python失败，请注意是否是网络问题？或尝试更改%~n1下载源？"
└─ 解决建议: 检查网络连接，更换下载源

错误码 3: PTH_FILE_WRITE_FAILED - PTH文件配置失败
├─ 发生阶段: 阶段5.4 - PTH文件修改
├─ 可能原因:
│   ├─ 文件只读属性
│   ├─ 管理员权限不足
│   ├─ 文件路径不存在
│   ├─ 磁盘已满
│   └─ 防病毒软件阻止
├─ 错误信息: "python*._pth文件写入失败"
└─ 解决建议: 以管理员权限运行，检查文件权限

错误码 4: PIP_INSTALL_FAILED - PIP安装失败
├─ 发生阶段: 阶段5.3 - get-pip.py执行
├─ 可能原因:
│   ├─ Python环境不完整
│   ├─ 网络连接超时
│   ├─ PyPI源不可用
│   ├─ 临时文件创建失败
│   └─ 系统环境变量冲突
├─ 错误信息: "python的pip模块安装失败，请注意是否是网络问题？或尝试更改PyPI源？"
└─ 解决建议: 检查网络，更换PyPI镜像源

错误码 5: GETPIP_DOWNLOAD_FAILED - get-pip.py下载失败
├─ 发生阶段: 阶段5.2 - get-pip.py下载
├─ 可能原因:
│   ├─ GitHub服务不可用
│   ├─ 镜像源故障
│   ├─ 代理设置错误
│   ├─ 本地网络限制
│   └─ 证书验证失败
├─ 错误信息: "下载get-pip.py失败，请注意是否是网络问题？或尝试更改get-pip.py下载源？"
└─ 解决建议: 更换下载源，检查网络代理设置

错误码 6: DEPENDENCY_INSTALL_FAILED - 依赖项部署失败
├─ 发生阶段: 阶段6 - 依赖包安装
├─ 可能原因:
│   ├─ requirements.txt格式错误
│   ├─ 依赖包版本冲突
│   ├─ 编译依赖缺失（如C++构建工具）
│   ├─ 平台不兼容的包
│   └─ 网络超时或中断
├─ 错误信息: "依赖项部署失败，请注意是否是网络问题？或尝试更改PyPI源？"
└─ 解决建议: 检查requirements.txt，安装构建工具

══════════════════════════════════════════════════════════════════════════════
                    高级特性与技术细节分析
══════════════════════════════════════════════════════════════════════════════

【智能编码检测机制】
├─ 技术原理: 利用中文字符编码特性进行检测
├─ 执行流程:
│   ├─ 设置测试字符串: "编码a" (包含中文和英文字符)
│   ├─ 提取第二个字符: !a:~2,1! (延迟变量扩展)
│   ├─ 正常UTF-8环境: 提取到中文字符的一部分
│   ├─ 异常环境: 可能提取到乱码或空字符
│   └─ 判断逻辑: 如果提取结果不是"a"，说明编码异常
└─ 自适应调整: 自动切换回GBK编码确保中文显示正常

【路径动态构建系统】
├─ 文件名提取技术:
│   ├─ %~n1: 从第一个参数URL中提取文件名（不含扩展名）
│   ├─ %~nx1: 提取文件名（含扩展名）
│   └─ 示例: 从URL提取"python-3.13.7-embed-amd64"
├─ 路径组合逻辑:
│   ├─ 工作目录: %cd% (脚本所在目录)
│   ├─ Python目录: %cd%\%~n1
│   └─ 脚本目录: %cd%\%~n1\Scripts
└─ 环境变量注入: 前置PATH确保优先使用部署的Python

【三级依赖安装策略】
├─ 第一级: 离线优先模式
│   ├─ 参数: --no-index --force-reinstall --find-links="离线包"
│   ├─ 特点: 完全不访问网络，仅使用本地包
│   └─ 适用场景: 已有完整离线包的环境
├─ 第二级: 包下载模式  
│   ├─ 命令: pip download -r requirements.txt -d "离线包"
│   ├─ 特点: 下载依赖包到本地，构建离线环境
│   └─ 适用场景: 准备离线安装或网络不稳定环境
└─ 第三级: 混合安装模式
    ├─ 参数: --force-reinstall --find-links=./离线包
    ├─ 特点: 优先使用离线包，缺失的包从网络下载
    └─ 适用场景: 平衡安装速度和成功率

【错误处理与回退机制】
├─ 快速部署静默失败: 任何错误都不提示，直接转入正常流程
├─ 正常部署显式错误: 每个步骤都有明确的错误码和描述
├─ 条件执行操作符: || 实现命令链的故障转移
└─ 渐进式部署策略: 确保每个组件独立验证

【环境隔离与清理】
├─ 工作目录隔离: 所有部署都在脚本目录进行
├─ 旧目录清理: 部署前删除可能存在的旧版本
├─ 临时文件管理: 下载的压缩包和脚本保留供后续使用
└─ 进程环境隔离: 通过新CMD会话确保环境变量生效
```

