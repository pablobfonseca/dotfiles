#!/usr/bin/env zsh

which curl >/dev/null || {
  echo "curl not found in path..."
  exit 1
}
which git >/dev/null || {
  echo "git not found in path..."
  exit 1
}

for BASE_DIR in "${HOME}/.vim" "${HOME}/.config/nvim"; do
  PATHOGEN_DIR="${BASE_DIR}/autoload"
  BUNDLES_DIR="${BASE_DIR}/bundle"

  if [[ -d "${PATHOGEN_DIR}" ]]; then
    echo "Updating pathogen in ${PATHOGEN_DIR}..."
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  fi

  if [[ -d "${BUNDLES_DIR}" ]]; then
    echo "Updating bundles in ${BUNDLES_DIR}..."
    for bundle in "${BUNDLES_DIR}/"*; do
      if [[ -d "${bundle}/.git" ]]; then
	echo "Bundle: ${bundle}..."
	cd "${bundle}"
	git pull
      fi
    done
  fi
done
