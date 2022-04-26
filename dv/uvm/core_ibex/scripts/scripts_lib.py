#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import argparse
import os
import re
import shlex
import subprocess
import sys
from typing import Dict, List, Optional, Tuple

THIS_DIR = os.path.dirname(__file__)
IBEX_ROOT = os.path.normpath(os.path.join(THIS_DIR, 4 * '../'))
RISCV_DV_ROOT = os.path.normpath(os.path.join(IBEX_ROOT,
                                              'vendor/google_riscv-dv'))

_OLD_SYS_PATH = sys.path
try:
    sys.path = [os.path.join(IBEX_ROOT, 'util')] + sys.path
    from ibex_config import parse_config
finally:
    sys.path = _OLD_SYS_PATH

TestAndSeed = Tuple[str, int]


def run_one(verbose: bool,
            cmd: List[str],
            redirect_stdstreams: Optional[str] = None,
            env: Dict[str, str] = None) -> int:
    '''Run a command, returning its return code

    If verbose is true, print the command to stderr first (a bit like bash -x).

    If redirect_stdstreams is true, redirect the stdout and stderr of the
    subprocess to the given path.

    '''
    if verbose:
        # The equivalent of bash -x
        cmd_str = ' '.join(shlex.quote(w) for w in cmd)
        if redirect_stdstreams is not None:
            cmd_str += f' >{shlex.quote(redirect_stdstreams)} 2>&1'

        print('+ ' + cmd_str, file=sys.stderr)

    stdstream_dest = None
    if redirect_stdstreams is not None:
        if redirect_stdstreams == '/dev/null':
            stdstream_dest = subprocess.DEVNULL
        else:
            stdstream_dest = open(redirect_stdstreams, 'wb')

    try:
        # Passing close_fds=False ensures that if cmd is a call to Make then
        # we'll pass through the jobserver fds. If you don't do this, you get a
        # warning starting "warning: jobserver unavailable".
        return subprocess.run(cmd,
                              stdout=stdstream_dest,
                              stderr=stdstream_dest,
                              close_fds=False,
                              env=env).returncode
    finally:
        if stdstream_dest not in [None, subprocess.DEVNULL]:
            stdstream_dest.close()


def start_riscv_dv_run_cmd(verbose: bool):
    '''Return the command parts of a call to riscv-dv's run.py'''
    riscv_dv_extension = os.path.join(THIS_DIR, '../riscv_dv_extension')

    csr_desc = os.path.join(riscv_dv_extension, 'csr_description.yaml')
    testlist = os.path.join(riscv_dv_extension, 'testlist.yaml')

    cmd = ['python3',
           os.path.join(RISCV_DV_ROOT, 'run.py'),
           '--testlist', testlist,
           '--gcc_opts=-mno-strict-align',
           '--custom_target', riscv_dv_extension,
           '--csr_yaml', csr_desc,
           '--mabi=ilp32']
    if verbose:
        cmd.append('--verbose')

    return cmd


def subst_vars(string: str, var_dict: Dict[str, str]) -> str:
    '''Apply substitutions in var_dict to string

    If var_dict[K] = V, then <K> will be replaced with V in string.'''
    for key, value in var_dict.items():
        string = string.replace('<{}>'.format(key), value)
    return string


def read_test_dot_seed(arg: str) -> TestAndSeed:
    '''Read a value for --test-dot-seed'''

    match = re.match(r'([^.]+)\.([0-9]+)$', arg)
    if match is None:
        raise argparse.ArgumentTypeError('Bad --test-dot-seed ({}): '
                                         'should be of the form TEST.SEED.'
                                         .format(arg))

    return (match.group(1), int(match.group(2), 10))


def get_isas_for_config(ibex_cfg: str) -> Tuple[str, str]:
    '''Get ISA and ISS_ISA keys for the given Ibex config'''
    yaml_path = os.path.join(IBEX_ROOT, "ibex_configs.yaml")
    cfg = parse_config(ibex_cfg, yaml_path)

    # NOTE: This logic should match the code in the get_isa_string() function
    # in core_ibex/tests/core_ibex_base_test.sv: keep them in sync!
    has_multiplier = cfg.rv32m != 'ibex_pkg::RV32MNone'
    base_isa = 'rv32{}{}c'.format('e' if cfg.rv32e else 'i',
                                  'm' if has_multiplier else '')

    bitmanip_mapping = {
        'ibex_pkg::RV32BNone': [],
        'ibex_pkg::RV32BBalanced': ['Zba', 'Zbb', 'Zbs', 'Xbitmanip'],
        'ibex_pkg::RV32BOTEarlGrey': ['Zba', 'Zbb', 'Zbc', 'Zbs', 'Xbitmanip'],
        'ibex_pkg::RV32BFull': ['Zba', 'Zbb', 'Zbc', 'Zbs', 'Xbitmanip'],
    }

    bitmanip_isa = bitmanip_mapping.get(cfg.rv32b)
    if bitmanip_isa is None:
        raise ValueError(f'Unknown RV32B value ({cfg.rv32b}) in config YAML')

    return (base_isa, '_'.join([base_isa] + bitmanip_isa))
