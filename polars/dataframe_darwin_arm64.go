//go:build darwin && arm64

package polars

/*
#cgo CFLAGS: -I.
#cgo LDFLAGS: -lfirn_darwin_arm64
#include "firn.h"
*/
import "C"
