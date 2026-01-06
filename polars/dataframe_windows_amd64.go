//go:build windows && amd64

package polars

/*
#cgo CFLAGS: -I.
#cgo LDFLAGS: -lfirn_windows_amd64
#include "firn.h"
*/
import "C"
