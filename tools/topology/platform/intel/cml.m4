include(`platform/intel/cnl.m4')
include(`abi.h')

#SSP setting for CML platform
undefine(`SSP_INDEX')
define(`SSP_INDEX', 0)

undefine(`SSP_NAME')
define(`SSP_NAME', `SSP0-Codec')

undefine(`SSP_MCLK_RATE')
define(`SSP_MCLK_RATE', `24000000')

include(`platform/intel/dmic.m4')

undefine(`DMIC0_PIPE_NAME')
define(`DMIC0_PIPE_NAME', `passthrough')

ifelse(SOF_ABI_VERSION_3_9_OR_GRT, `1',
`undefine(`SSP_PIPE_NAME')
define(`SSP_PIPE_NAME', `volume')',
`undefine(`SSP_PIPE_NAME')
define(`SSP_PIPE_NAME', `src-volume')')

undefine(`DMIC_PCM_NUM')
define(`DMIC_PCM_NUM', `2')

undefine(`DMIC01_FMT')
define(`DMIC01_FMT', `s32le')

undefine(`DMIC1_FMT')
define(`DMIC1_FMT', `s24le')

ifelse(SOF_ABI_VERSION_3_9_OR_GRT, `1',
`undefine(`AMP_DAI_FMT')
define(`AMP_DAI_FMT', `s24le')',
`undefine(`AMP_DAI_FMT')
define(`AMP_DAI_FMT', `s16le')')

undefine(`HDMI0_INDEX')
define(`HDMI0_INDEX', `0')

undefine(`HDMI1_INDEX')
define(`HDMI1_INDEX', `1')

undefine(`HDMI2_INDEX')
define(`HDMI2_INDEX', `2')

ifelse(SOF_ABI_VERSION_3_9_OR_GRT, `1',
`undefine(`SSP1_BCLK_RATE')
define(`SSP1_BCLK_RATE', `2304000')',
`undefine(`SSP1_BCLK_RATE')
define(`SSP1_BCLK_RATE', `1500000')')

undefine(`SSP_BCLK_RATE')
define(`SSP_BCLK_RATE', `2400000')

ifelse(SOF_ABI_VERSION_3_9_OR_GRT, `1',
`undefine(`SSP_LRCLK_RATE')
define(`SSP_LRCLK_RATE', `48000')',
`undefine(`SSP_LRCLK_RATE')
define(`SSP_LRCLK_RATE', `46875')')

undefine(`SSP_BITS_WIDTH')
define(`SSP_BITS_WIDTH', `25')

ifelse(SOF_ABI_VERSION_3_9_OR_GRT, `1',
`undefine(`TDM_WIDTH')
define(`TDM_WIDTH', `24')',
`undefine(`TDM_WIDTH')
define(`TDM_WIDTH', `16')')

undefine(`SSP1_VALID_BITS')
define(`SSP1_VALID_BITS', `24')

undefine(`SSP_VALID_BITS')
define(`SSP_VALID_BITS', `16')

undefine(`MCLK_ID')
define(`MCLK_ID', `')

undefine(`UNUSED_SSP_ROUTE1')
define(`UNUSED_SSP_ROUTE1', `ssp5')

undefine(`UNUSED_SSP_ROUTE2')
define(`UNUSED_SSP_ROUTE2', `ssp1')
