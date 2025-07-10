PXE_VERSION=3.3.1

MARKETPLACE_PXE_REPO="709825985650.dkr.ecr.us-east-1.amazonaws.com/portworx"
MARKETPLACE_PXE_DR_REPO="709825985650.dkr.ecr.us-east-1.amazonaws.com/portworx/dr"

.PHONY: pull-images

pull-images:
	@curl -fsSL https://install.portworx.com/$(PXE_VERSION)/version -o ./version
	@curl -fsSL https://install.portworx.com/$(PXE_VERSION)/air-gapped -o ./air-gapped

	docker pull $$(yq -r .components.autopilot ./version)
	docker pull $$(yq -r .components.stork ./version)

	docker pull $$(cat ./air-gapped | grep 'oci-monitor' | sed 's/IMAGES="$$IMAGES //' | tr -d '"')
	docker pull $$(cat ./air-gapped | grep 'px-enterprise' | sed 's/IMAGES="$$IMAGES //' | tr -d '"')
	docker pull $$(cat ./air-gapped | grep 'px-operator' | sed 's/IMAGES="$$IMAGES //' | tr -d '"')

	autopilot_version=$$(yq -r .components.autopilot ./version | cut -d ':' -f 2); \
		docker tag $$(yq -r .components.autopilot ./version) $(MARKETPLACE_PXE_REPO)/autopilot:$$autopilot_version; \
		docker tag $$(yq -r .components.autopilot ./version) $(MARKETPLACE_PXE_DR_REPO)/autopilot:$$autopilot_version

	stork_version=$$(yq -r .components.stork ./version | cut -d ':' -f 2); \
		docker tag $$(yq -r .components.stork ./version) $(MARKETPLACE_PXE_REPO)/stork:$$stork_version; \
		docker tag $$(yq -r .components.stork ./version) $(MARKETPLACE_PXE_DR_REPO)/stork:$$stork_version

	oci_monitor=$$(cat ./air-gapped | grep 'oci-monitor' | sed 's/IMAGES="$$IMAGES //' | tr -d '"'); \
		oci_monitor_version=$$(echo $$oci_monitor | cut -d ':' -f 2); \
		docker tag $$oci_monitor $(MARKETPLACE_PXE_REPO)/oci-monitor:$$oci_monitor_version; \
		docker tag $$oci_monitor $(MARKETPLACE_PXE_DR_REPO)/oci-monitor:$$oci_monitor_version

	px_enterprise=$$(cat ./air-gapped | grep 'px-enterprise' | sed 's/IMAGES="$$IMAGES //' | tr -d '"'); \
		px_enterprise_version=$$(echo $$px_enterprise | cut -d ':' -f 2); \
		docker tag $$px_enterprise $(MARKETPLACE_PXE_REPO)/px-enterprise:$$px_enterprise_version; \
		docker tag $$px_enterprise $(MARKETPLACE_PXE_DR_REPO)/px-enterprise:$$px_enterprise_version

	px_operator=$$(cat ./air-gapped | grep 'px-operator' | sed 's/IMAGES="$$IMAGES //' | tr -d '"'); \
		px_operator_version=$$(echo $$px_operator | cut -d ':' -f 2); \
		docker tag $$px_operator $(MARKETPLACE_PXE_REPO)/px-operator:$$px_operator_version; \
		docker tag $$px_operator $(MARKETPLACE_PXE_DR_REPO)/px-operator:$$px_operator_version

	@rm -f ./air-gapped ./version

push-images:
	@curl -fsSL https://install.portworx.com/$(PXE_VERSION)/version -o ./version
	@curl -fsSL https://install.portworx.com/$(PXE_VERSION)/air-gapped -o ./air-gapped

	autopilot_version=$$(yq -r .components.autopilot ./version | cut -d ':' -f 2); \
		docker push $(MARKETPLACE_PXE_REPO)/autopilot:$$autopilot_version

	stork_version=$$(yq -r .components.stork ./version | cut -d ':' -f 2); \
		docker push $(MARKETPLACE_PXE_REPO)/stork:$$stork_version

	oci_monitor_version=$$(cat ./air-gapped | grep 'oci-monitor' | sed 's/IMAGES="$$IMAGES //' | tr -d '"' | cut -d ':' -f 2); \
		docker push $(MARKETPLACE_PXE_REPO)/oci-monitor:$$oci_monitor_version

	px_enterprise_version=$$(cat ./air-gapped | grep 'px-enterprise' | sed 's/IMAGES="$$IMAGES //' | tr -d '"' | cut -d ':' -f 2); \
		docker push $(MARKETPLACE_PXE_REPO)/px-enterprise:$$px_enterprise_version

	px_operator_version=$$(cat ./air-gapped | grep 'px-operator' | sed 's/IMAGES="$$IMAGES //' | tr -d '"' | cut -d ':' -f 2); \
		docker push $(MARKETPLACE_PXE_REPO)/px-operator:$$px_operator_version

	@rm -f ./air-gapped ./version

push-images-dr:
	@curl -fsSL https://install.portworx.com/$(PXE_VERSION)/version -o ./version
	@curl -fsSL https://install.portworx.com/$(PXE_VERSION)/air-gapped -o ./air-gapped

	autopilot_version=$$(yq -r .components.autopilot ./version | cut -d ':' -f 2); \
		docker push $(MARKETPLACE_PXE_DR_REPO)/autopilot:$$autopilot_version

	stork_version=$$(yq -r .components.stork ./version | cut -d ':' -f 2); \
		docker push $(MARKETPLACE_PXE_DR_REPO)/stork:$$stork_version

	oci_monitor_version=$$(cat ./air-gapped | grep 'oci-monitor' | sed 's/IMAGES="$$IMAGES //' | tr -d '"' | cut -d ':' -f 2); \
		docker push $(MARKETPLACE_PXE_DR_REPO)/oci-monitor:$$oci_monitor_version

	px_enterprise_version=$$(cat ./air-gapped | grep 'px-enterprise' | sed 's/IMAGES="$$IMAGES //' | tr -d '"' | cut -d ':' -f 2); \
		docker push $(MARKETPLACE_PXE_DR_REPO)/px-enterprise:$$px_enterprise_version

	px_operator_version=$$(cat ./air-gapped | grep 'px-operator' | sed 's/IMAGES="$$IMAGES //' | tr -d '"' | cut -d ':' -f 2); \
		docker push $(MARKETPLACE_PXE_DR_REPO)/px-operator:$$px_operator_version

	@rm -f ./air-gapped ./version