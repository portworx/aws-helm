# AWS Marketplace ECR repos
MARKETPLACE_PXE_REPO = 709825985650.dkr.ecr.us-east-1.amazonaws.com/portworx
MARKETPLACE_PXE_DR_REPO = 709825985650.dkr.ecr.us-east-1.amazonaws.com/portworx/dr

# Version configuration
PXE_VERSION := 3.3.1.3
OPERATOR_VERSION := 25.2.2
AUTOPILOT_VERSION := 1.3.17
STORK_VERSION := 25.3.2

BRANCH ?= master

COMPONENTS := px-enterprise oci-monitor operator autopilot stork

# Images
px-enterprise_image := docker.io/portworx/px-enterprise:$(PXE_VERSION)
oci-monitor_image := docker.io/portworx/oci-monitor:$(PXE_VERSION)
operator_image := docker.io/portworx/px-operator:$(OPERATOR_VERSION)
autopilot_image := docker.io/portworx/autopilot:$(AUTOPILOT_VERSION)
stork_image := docker.io/openstorage/stork:$(STORK_VERSION)

# Helper functions to get mapping values
src_image = $(if $($(1)_image),$($(1)_image),$(error Image not defined for '$(1)'))
dest_image = $(subst docker.io/portworx,$(1),$(subst docker.io/openstorage,$(1),$(call src_image,$(2))))

.PHONY: pull publish

pull: $(addprefix pull-,$(COMPONENTS))

publish: $(addprefix publish-,$(COMPONENTS))

list: $(addprefix list-,$(COMPONENTS))

listdr: $(addprefix listdr-,$(COMPONENTS))

pull-%:
	@echo "Pulling image $*"
	docker pull $(call src_image,$*)
	docker tag $(call src_image,$*) $(call dest_image,$(MARKETPLACE_PXE_REPO),$*)
	docker tag $(call src_image,$*) $(call dest_image,$(MARKETPLACE_PXE_DR_REPO),$*)

publish-%:
	@echo "Pushing image $(call dest_image,$(MARKETPLACE_PXE_REPO),$*)"
	docker push $(call dest_image,$(MARKETPLACE_PXE_REPO),$*)
	@echo "Pushing image $(call dest_image,$(MARKETPLACE_PXE_DR_REPO),$*)"
	docker push $(call dest_image,$(MARKETPLACE_PXE_DR_REPO),$*)

package-helm:
	@echo "Packaging helm chart for portworx enterprise"
	cd stable && helm package ../portworx && helm repo index . --url https://raw.githubusercontent.com/portworx/aws-helm/$(BRANCH)/stable

list-%:
	@echo "$(call dest_image,$(MARKETPLACE_PXE_REPO),$*)"

listdr-%:
	@echo "$(call dest_image,$(MARKETPLACE_PXE_DR_REPO),$*)"
