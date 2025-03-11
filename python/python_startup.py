from pprint import pp


def override_print():
    import builtins
    original_print = builtins.print
    def custom_print(*args, **kwargs):
        import inspect
        frame = inspect.currentframe().f_back
        filename = frame.f_code.co_filename
        lineno = frame.f_lineno
        original_print(f"[{filename}:{lineno}] ", end="")
        original_print(*args, **kwargs)
    builtins.print = custom_print


def mklist(iterable, num_frames=1):
    import inspect
    from collections.abc import Iterable, Iterator

    if isinstance(iterable, list):
        return iterable

    converted_list = list(iterable)

    if isinstance(iterable, Iterator) or not isinstance(iterable, Iterable):
        current_frame = inspect.currentframe()
        for _ in range(num_frames):
            caller_frame = current_frame.f_back
            frame_locals = caller_frame.f_locals
            var_names = [name for name, val in frame_locals.items() if val is iterable]
            frame_locals.update({
                name: converted_list
                for name in var_names
            })
            current_frame = caller_frame

    return converted_list


def print_shell_cmd(cmd_args):
    import shlex
    def get_line_groups(args):
        iterator = iter(args)
        try:
            cur_group = [next(iterator)]
        except StopIteration:
            yield from ()
            return
        for arg in iterator:
            if arg.startswith('-'):
                yield cur_group
                cur_group = [arg]
            else:
                cur_group.append(arg)
        yield cur_group
    lines = map(
        lambda group: shlex.join(group),
        get_line_groups(mklist(cmd_args, num_frames=2)),
    )
    print(" \\\n  ".join(lines))


def print_args():
    import shlex
    import sys
    print_shell_cmd(sys.argv)
    print('\n{}'.format(shlex.join(sys.argv)))
