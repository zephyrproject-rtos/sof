# SPDX-License-Identifier: Apache-2.0

# Copyright (c) 2021 Intel Corporation
# Copyright (c) 2020 Espressif Systems (Shanghai) Co., Ltd.
#

'''update.py

SOF west extension to retrieve submodules.'''

import os
import platform
import subprocess
from pathlib import Path

from textwrap import dedent
from west.commands import WestCommand
from west import log

SOF_REMOTE = "https://github.com/zephyrproject-rtos/sof"


def cmd_check(cmd, cwd=None, stderr=subprocess.STDOUT):
    return subprocess.check_output(cmd, cwd=cwd, stderr=stderr)


def cmd_exec(cmd, cwd=None, shell=False):
    return subprocess.check_call(cmd, cwd=cwd, shell=shell)


class UpdateTool(WestCommand):

    def __init__(self):
        super().__init__(
            'sof',
            # Keep this in sync with the string in west-commands.yml.
            'download SOF submodules',
            dedent('''
            This interface allows updated SOF submodules
            required for SOF framework.'''),
            accepts_unknown_args=False)

    def do_add_parser(self, parser_adder):
        parser = parser_adder.add_parser(self.name,
                                         help=self.help,
                                         description=self.description)

        parser.add_argument('command', choices=['update'],
                            help='fetch submodules')

        return parser

    def do_run(self, args, unknown_args):

        module_path = (
            Path(os.getenv("ZEPHYR_BASE")).absolute()
            / r".."
            / "modules"
            / "audio"
            / "sof"
        )

        if not module_path.exists():
            log.die('cannot find SOF project in $ZEPHYR_BASE path')

        if args.command == "update":
            self.update(module_path)
        elif args.command == "install":
            self.install(module_path)

    def update(self, module_path):
        log.banner('updating SOF submodules..')

        # look for origin remote
        remote_name = cmd_check(("git", "remote"),
                                cwd=module_path).decode('utf-8')

        if "origin" not in remote_name:
            # add origin url
            cmd_exec(("git", "remote", "add", "origin",
                     SOF_REMOTE), cwd=module_path)
        else:
            remote_url = cmd_check(("git", "remote", "get-url", "origin"),
                                   cwd=module_path).decode('utf-8')
            # update origin URL
            if SOF_REMOTE not in remote_url:
                cmd_exec(("git", "remote", "set-url", "origin",
                         SOF_REMOTE), cwd=module_path)

        cmd_exec(("git", "submodule", "update", "--init", "--recursive"),
                 cwd=module_path)

        log.banner('updating SOF submodules completed')
