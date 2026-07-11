rm -f kira.log
rm -f firefly.log
rm -rf results
rm -rf tmp
rm -rf sectormappings
rm -rf firefly_saves
rm -rf ff_save
dos2unix list
dos2unix userSystem/ibp.kira
dos2unix jobs.yaml
/home/jiaqichen/Softwares/kira/bin/kira --parallel=10 jobs.yaml
