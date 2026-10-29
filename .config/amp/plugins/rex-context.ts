import type { PluginAPI } from '@ampcode/plugin'

export const description = 'Adds Rex session and pane context to Amp turns launched in Rex.'

export default function (amp: PluginAPI) {
	amp.on('agent.start', async (_event, ctx) => {
		const result = await ctx.$`rex __internal session-start --agent amp --feature-session-naming=false`

		if (result.exitCode !== 0 || !result.stdout.trim()) return

		return {
			message: {
				content: result.stdout.trim(),
				display: false,
			},
		}
	})
}
