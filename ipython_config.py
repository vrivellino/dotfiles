# Configuration file for ipython.

import os
c = get_config()

#------------------------------------------------------------------------------
# InteractiveShellApp configuration
#------------------------------------------------------------------------------

## lines of code to run at IPython startup.
c.InteractiveShellApp.exec_lines = [
    '%autoreload 2',
    'print("Warning: disable autoreload in ipython_config.py to improve performance.")',
]

## A list of dotted module names of IPython extensions to load.
c.InteractiveShellApp.extensions = ['autoreload']

# List of files to run at IPython startup.
c.InteractiveShellApp.exec_files = [
    os.path.join(os.environ['HOME'], '.dotfiles', 'ipython', 'startup-exec.py')
]

c.InteractiveShell.xmode = 'Context'
