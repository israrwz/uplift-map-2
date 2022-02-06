<script context="module">
	/** @type {import('@sveltejs/kit').Load} */
	export async function load({ params, fetch, session, stuff }) {
		const url = `/districts.json`;
		const res = await fetch(url);
		const map = await fetch('/maps/provinces-simplified.json');
		//		const stats = await fetch('/stats.json');
		const stats = await fetch('https://nodered.speensoft.net/get-provinces-stats');
		// const map = await fetch(
		// 	'https://raw.githubusercontent.com/Sarah-W/svelte-geo/main/src/_geojson/rto2017_simplified_3dp.geojson.json'
		// );

		if (res.ok && map.ok) {
			let data = await res.json();
			let map_data = await map.json();
			let stats_json = await stats.json();
			console.log(data.provinces['AF21']);
			let stats_data = {};
			stats_json.forEach(itm=>{
				stats_data[itm.max.substring(0,4)]=itm;
			})
			// console.log(map_data);
			return {
				props: {
					districts: data.districts,
					provinces: data.provinces,
					map: map_data,
					stats: stats_data
				}
			};
		}

		return {
			status: res.status,
			error: new Error(`Could not load ${url}`)
		};
	}
</script>

<script>
	import SvelteMap from '../components/SvelteMap.svelte';
	export let map;
	export let districts;
	export let provinces;
	export let stats;
</script>

<SvelteMap data={map} {provinces} {districts} {stats} />

<style>
	:global(body) {
		margin: 0px;
		padding: 0px;
	}
</style>
