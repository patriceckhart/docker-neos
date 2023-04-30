set -e

[ -f /etc/ssh/ssh_host_rsa_key ] || ssh-keygen -q -b 1024 -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key
[ -f /etc/ssh/ssh_host_dsa_key ] || ssh-keygen -q -b 1024 -N '' -t dsa -f /etc/ssh/ssh_host_dsa_key
[ -f /etc/ssh/ssh_host_ecdsa_key ] || ssh-keygen -q -b 521  -N '' -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
[ -f /etc/ssh/ssh_host_ed25519_key ] || ssh-keygen -q -b 1024 -N '' -t ed25519 -f /etc/ssh/ssh_host_ed25519_key

[ -d /data/.ssh ] || mkdir /data/.ssh
[ -f /data/.ssh/authorized_keys ] || touch /data/.ssh/authorized_keys
chown www-data:www-data -R /data/.ssh
chmod go-w /data/
chmod 700 /data/.ssh
chmod 600 /data/.ssh/authorized_keys

PASS=$(pwgen -c -n -1 16)
echo "www-data:$PASS" | chpasswd

if [ -z "${GITHUB_USERNAME+xxx}" ] || [ -z "${GITHUB_USERNAME}" ]; then
  echo "WARNING: env variable \$GITHUB_USERNAME is not set. Please set it to have access to this container via SSH."
else
  for user in $(echo $GITHUB_USERNAME | tr "," "\n"); do
    echo "user: $user"
    su www-data -c "/root-files/opt/github-public-keys.sh $user"
  done
fi
