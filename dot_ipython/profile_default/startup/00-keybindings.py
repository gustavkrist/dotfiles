from IPython import get_ipython
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.filters import HasFocus, ViInsertMode, ViNavigationMode
from prompt_toolkit.key_binding.vi_state import InputMode
from functools import partial


def setup_keybindings():
    ipython = get_ipython()
    if not ipython:
        return
    pt_app = ipython.pt_app
    if not pt_app:
        return
    keybindings = pt_app.key_bindings

    vi_navigation_mode_keybinding = partial(keybindings.add, filter=HasFocus(DEFAULT_BUFFER) & ViNavigationMode())
    vi_insert_mode_keybinding = partial(keybindings.add, filter=HasFocus(DEFAULT_BUFFER) & ViInsertMode())


    @vi_insert_mode_keybinding("j", "k")
    def switch_to_navigation_mode(event):
        event.cli.vi_state.input_mode = InputMode.NAVIGATION


setup_keybindings()
