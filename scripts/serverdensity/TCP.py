import subprocess

class TCP(object):
    def __init__(self, agentConfig, checksLogger, rawConfig):
        self.agentConfig = agentConfig
        self.checksLogger = checksLogger
        self.rawConfig = rawConfig
    
    def run(self):
        stats = {}
        netstat = subprocess.Popen(
            ['netstat','--inet', '--numeric'],
            stdout=subprocess.PIPE,
        )
        awk = subprocess.Popen(
            ['awk', '{print $4}'],
            stdin=netstat.stdout, stdout=subprocess.PIPE,
        )
        grep = subprocess.Popen(
            ['grep', ':80'],
            stdin=awk.stdout, stdout=subprocess.PIPE,
        )
        wc = subprocess.Popen(
            ['wc', '-l'],
            stdin=grep.stdout, stdout=subprocess.PIPE,
        )
        stats['HTTP Connections'] = wc.communicate()[0].strip()
        
        return stats

