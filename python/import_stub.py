def import_module_from_path(module_name, file_path):
    """
    Dynamically imports a Python module given its file path.

    :param module_name: Name to assign to the imported module.
    :param file_path: Full path to the Python file.
    :return: The imported module.
    """
    spec = importlib.util.spec_from_file_location(module_name, file_path)
    if spec and spec.loader:
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        return module
    else:
        raise ImportError(f"Cannot load module from {file_path}")



import importlib
spec = importlib.util.spec_from_file_location('my_debug', '/home/coleman/code/dotfiles/python/import_stub.py')
my_debug = importlib.util.module_from_spec(my_debug)
spec.loader.exec_module(my_debug)
breakpoint()
