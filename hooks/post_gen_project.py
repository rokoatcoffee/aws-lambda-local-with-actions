from os import system

git = 'git init'
poetry = 'poetry install'


def try_except(command, message):
    try:
        print(f"+ {command}")
        system(command)
    except Exception as e:
        print(f"{message}: {e}")


try_except(git, 'git exception')
try_except(poetry, 'poetry exception')
