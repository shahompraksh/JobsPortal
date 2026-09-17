<?php
declare(strict_types=1);

$cfg['blowfish_secret'] = 'jobsportal-local-development-only-key';
$i = 1;
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = 'localhost';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = true;
