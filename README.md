# puppet-dropbear

Manage [dropbear](https://matt.ucc.asn.au/dropbear/dropbear.html) SSH server via Puppet

## Usage

```
  class {
    'dropbear':
      no_start        => '0',
      ssh_port        => '443',
      ssh_args        => '-s',
      banner          => 'Powered by dropbear',
  }
```

## Other class parameters
* ensure: present or absent, (default: present)
* no\_start: boolean, 0 for start dropbear, and 1 for stop (init), (default: 1, stop)
* ssh\_port: integer, ssh TCP port listens on (default: 22)
* ssh\_args: string, dropbear ssh args (refs: man dropbear)
* banner: string, banner file containing a message to be sent to clients before they connect
* rsakey: string, RSA hostkey file (default: /etc/dropbear/dropbear\_rsa\_host\_key)
* dsskey: string, DSS hostkey file (default: /etc/dropbear/dropbear\_dss\_host\_key)
* receive\_window: string, Receive window size, this is a tradeoff between memory and network performance (default: 65536)
