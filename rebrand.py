import sys
import subprocess

GIT_REMOTE_BASE = 'git@bitbucket.org:endlesscoil/{0}.git'

def update_project(app_name, readable_name):
    with open('project.flow', 'r+') as f:
        data = f.read()
    
        data = data.replace('%APP_NAME%', app_name)
        data = data.replace('%READABLE_NAME%', readable_name)
    
        f.seek(0)
        f.truncate()
        f.write(data)

def update_git(path):
    subprocess.call(['git', 'remote', 'rename', 'origin', 'template'])
    subprocess.call(['git', 'remote', 'add', 'origin', path])

def main():
    if len(sys.argv) <= 1:
        print 'Usage: {0} <app name> <human readable title>'.format(sys.argv[0])
        return

    app_name = sys.argv[1]
    readable_name = ' '.join(sys.argv[2:])

    print 'Updating project..'
    print
    print '   Application Name: {0}'.format(app_name)
    print 'Human Readable Name: {0}'.format(readable_name)

    update_project(app_name, readable_name)
    update_git(GIT_REMOTE_BASE.format(app_name))

if __name__ == '__main__':
    main()
