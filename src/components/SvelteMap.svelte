<script>
	import { onMount } from 'svelte';
	import { browser } from '$app/env';
	import bbox from 'geojson-bbox';

	onMount(async () => {
		if (browser) {
			const leaflet = await import('leaflet');
			const initzoom = await import('$lib/smoothzoom.js');
			initzoom.default(leaflet);
			const map = leaflet
				.map('map', {
					scrollWheelZoom: false,
					smoothWheelZoom: true,
					smoothSensitivity: 1,
					zoomSnap: 0.1,
					zoomDelta: 1
				})
				.setView([34, 69], 7);
			map.scrollWheelZoom = true;
			// map.dragging.disable();

			// leaflet
			// 	.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
			// 		attribution:
			// 			'© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
			// 	})
			// 	.addTo(map);
			let myStyle = {
				// color: '#fce1cb',
				// color: '#ff7800',
				fillColor: '#ff7800',
				weight: 0.3,
				opacity: 1
			};

			leaflet.geoJson(data, { style: myStyle, onEachFeature: onFeature }).addTo(map);

			let extent = bbox(data);

			// let bounds = leaflet.latLngBounds();
			// bounds.extend(leaflet.latLng(extent[0], extent[1]));
			// bounds.extend(leaflet.latLng(extent[2], extent[3]));

			let corner1 = leaflet.latLng(extent[1], extent[0]),
				corner2 = leaflet.latLng(extent[3], extent[2]),
				bounds = leaflet.latLngBounds(corner1, corner2);
			console.log(extent);
			map.fitBounds(bounds, {});

			// window.map = map;
		}
	});

	const onFeature = (feature, layer) => {
		layer.on('mouseover', function () {
			this.setStyle({
				fillColor: '#ffa830'

				// opacity: 0.4
			});
		});
		layer.on('mouseout', function () {
			this.setStyle({
				fillColor: '#ff7800'
				// opacity: 1
			});
		});
		layer.on('click', function () {
			// Let's say you've got a property called url in your geojsonfeature:
			console.log(feature.properties.ADM1_PCODE);
		});
	};

	export let data;
</script>

<main>
	<div id="map" />
	<div id="box">asdf</div>
</main>

<style>
	/* @import 'https://unpkg.com/leaflet@1.7.1/dist/leaflet.css'; */
	@import 'leaflet/dist/leaflet.css';
	main {
		/* grid-template-columns: au; */
		/* display: grid; */
		display: block;
	}

	main #map {
		height: 50vh;
		width: 100%;
		grid-column: 1;
		/* width: 800px; */
	}
	main #box {
		height: 50vh;
		width: 100%;
		grid-column: 2;
	}

	@media (min-width: 600px) {
		main {
			display: grid;
			grid-template-columns: 3fr 1fr;
		}
		main #map,
		main #box {
			height: 100vh;
		}
	}
	:global(.leaflet-container),
	#box {
		background: #fafaf5;
	}
</style>
