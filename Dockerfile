FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
RUN echo -ne "[centos-8-baseos]\nname = CentOS 8 (RPMs) - BaseOS\nbaseurl = http://mirror.centos.org/centos-8/8/extras/x86_64/os/\nenabled = 1\ngpgcheck = 0" > /etc/yum.repos.d/centos.repo
RUN echo -ne "[centos-8-ansible]\nname = CentOS 8 Ansible (RPMs)\nbaseurl = http://mirror.centos.org/centos-8/8/configmanagement/x86_64/ansible-29/\nenabled = 1\ngpgcheck = 0" > /etc/yum.repos.d/ansible.repo
RUN microdnf -y install python3 ansible; microdnf clean all
RUN pip3 install openshift
COPY ./chown-executor.yaml entrypoint.yaml
COPY pod.yml.j2 pod.yml.j2
ENTRYPOINT [ "/usr/bin/ansible-playbook", "entrypoint.yaml", "-e namespace=${NAMESPACE}", "-e pvcs=${PVCS}", "-e context=${CONTEXT}" ]
