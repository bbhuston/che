#!/usr/bin/env bash
# Copyright (c) 2018 Red Hat, Inc.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
set -x

echo "========Starting nigtly test job $(date)========"

source tests/.infra/centos-ci/functional_tests_utils.sh
source .ci/cico_common.sh

installKVM
installDependencies
installCheCtl
installAndStartMinishift
loginToOpenshiftAndSetDevRole
deployCheIntoCluster --chenamespace=eclipse-che --che-operator
seleniumTestsSetup
createTestUserAndObtainUserToken
installDockerCompose
seleniumTestsSetup
bash tests/legacy-e2e/che-selenium-test/selenium-tests.sh --threads=3 --host=${CHE_ROUTE} --port=80 --multiuser
saveSeleniumTestResult
getOpenshiftLogs
archiveArtifacts "che-nigthly-multiuser-stable-test"


