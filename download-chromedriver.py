#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import requests
import zipfile
import tarfile
import platform
import subprocess

def get_chrome_version():
    try:
        # 尝试使用 google-chrome --version 命令获取 Chrome 版本
        result = subprocess.run(
            ['google-chrome', '--version'],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        output = result.stdout.decode('utf-8').strip()
        if result.returncode == 0 and output:
            # 解析版本号，例如：Google Chrome 145.0.7632.116
            version_info = output.split(' ')
            if len(version_info) >= 3:
                chrome_version = version_info[2]
                return chrome_version.split('.')[0]
        return None
    except Exception as e:
        print(f'获取 Chrome 版本失败: {e}')
        return None

def download_chromedriver(chrome_version):
    try:
        # 下载 ChromeDriver
        url = f'https://storage.googleapis.com/chrome-for-testing-public/{chrome_version}.0.7680.66/linux64/chromedriver-linux64.zip'
        print(f'正在下载 ChromeDriver {chrome_version}.0.7680.66...')

        response = requests.get(url, timeout=30)
        response.raise_for_status()

        # 保存下载的文件
        download_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'chromedriver-linux64.zip')
        with open(download_path, 'wb') as f:
            f.write(response.content)
        print(f'ChromeDriver 下载成功: {download_path}')

        # 解压文件
        print('正在解压 ChromeDriver...')
        with zipfile.ZipFile(download_path, 'r') as zip_ref:
            zip_ref.extractall(os.path.dirname(os.path.abspath(__file__)))

        # 赋予执行权限
        chromedriver_path = os.path.join(
            os.path.dirname(os.path.abspath(__file__)),
            'chromedriver-linux64',
            'chromedriver'
        )
        os.chmod(chromedriver_path, 0o755)
        print(f'ChromeDriver 解压成功: {chromedriver_path}')

        # 创建软链接到系统目录
        system_chromedriver_path = '/usr/local/bin/chromedriver'
        if os.path.exists(system_chromedriver_path):
            try:
                os.remove(system_chromedriver_path)
            except Exception as e:
                print(f'删除旧 ChromeDriver 失败: {e}')

        try:
            os.symlink(chromedriver_path, system_chromedriver_path)
            print(f'ChromeDriver 软链接创建成功: {system_chromedriver_path}')
        except Exception as e:
            print(f'ChromeDriver 软链接创建失败: {e}')

        return chromedriver_path

    except Exception as e:
        print(f'ChromeDriver 下载失败: {e}')
        return None

def main():
    print('=== ChromeDriver 下载工具 ===')

    # 获取 Chrome 版本
    chrome_version = get_chrome_version()
    if not chrome_version:
        print('无法获取 Chrome 版本')
        sys.exit(1)

    print(f'Chrome 版本: {chrome_version}')

    # 下载 ChromeDriver
    chromedriver_path = download_chromedriver(chrome_version)
    if not chromedriver_path:
        print('ChromeDriver 下载失败')
        sys.exit(1)

    # 验证 ChromeDriver 版本
    try:
        result = subprocess.run(
            [chromedriver_path, '--version'],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        print(f'ChromeDriver 版本: {result.stdout.decode("utf-8").strip()}')
    except Exception as e:
        print(f'ChromeDriver 版本验证失败: {e}')

if __name__ == '__main__':
    main()
